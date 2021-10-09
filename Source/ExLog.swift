//
//


import Foundation
import os.log

/// A logging facility based on tags to switch on and off certain logs
///
/// - Note:
/// Usage. Add:
///
///     ```
///     private let zmLog = ZMLog(tag: "Networking")
///     ```
///
/// at the top of your .swift file and log with:
///
///     zmLog.debug("Debug information")
///     zmLog.warn("A serious warning!")
///
@objc
public class ExLog : NSObject {

    public typealias LogHook = (_ level: ZMLogLevel_t, _ tag: String?, _ message: String) -> (Void)
    public typealias LogEntryHook = (
        _ level: ZMLogLevel_t,
        _ tag: String?,
        _ message: ZMSLogEntry,
        _ isSafe: Bool) -> (Void)

    /// Tag to use for this logging facility
    fileprivate let tag: String

    /// FileHandle instance used for updating the log
    fileprivate static var updatingHandle: FileHandle?

    /// Log observers
    fileprivate static var logHooks : [UUID : LogEntryHook] = [:]
    
    @objc public init(tag: String) {
        self.tag = tag
    }
    
    /// Wait for all log operations to be completed
    @objc
    public static func sync() {
        exLogQueue.sync {
            // no op
        }
    }
}

// MARK: - Emit logs
extension ExLog {
    
    public func info(_ message: @autoclosure () -> String, file: String = #file, line: UInt = #line) {
        ExLog.logWithLevel(.info, message: message(), tag: self.tag, file: file, line:line)
    }

}

// MARK: - Hooks (log observing)
extension ExLog {
    
    /// Notify all hooks of a new log
    fileprivate static func notifyHooks(level: ZMLogLevel_t,
                                        tag: String?,
                                        entry: ZMSLogEntry,
                                        isSafe: Bool) {
        self.logHooks.forEach { (_, hook) in
            hook(level, tag, entry, isSafe)
        }
    }

    // MARK: - Rich Hooks

    /// Adds a log hook
    @objc static public func addEntryHook(logHook: @escaping LogEntryHook) -> LogHookToken {
        var token : LogHookToken! = nil
        exLogQueue.sync {
            token = self.nonLockingAddEntryHook(logHook: logHook)
        }
        return token
    }

    /// Adds a log hook without locking
    @objc static public func nonLockingAddEntryHook(logHook: @escaping LogEntryHook) -> LogHookToken {
        let token = LogHookToken()
        self.logHooks[token.token] = logHook
        return token
    }

    
    /// Remove a log hook
    @objc static public func removeLogHook(token: LogHookToken) {
        exLogQueue.sync {
            _ = self.logHooks.removeValue(forKey: token.token)
        }
    }
    
    /// Remove all log hooks
    @objc static public func removeAllLogHooks() {
        exLogQueue.sync {
            self.logHooks = [:]
        }
    }
}

// MARK: - Internal stuff
extension ExLog {
    
    @objc static public func logWithLevel(_ level: ZMLogLevel_t, message:  @autoclosure () -> String, tag: String?, file: String = #file, line: UInt = #line) {
        let entry = ZMSLogEntry(text: message(), timestamp: Date())
        logEntry(entry, level: level, isSafe: false, tag: tag, file: file, line: line)
    }
    
    static private func logEntry(
        _ entry: ZMSLogEntry,
        level: ZMLogLevel_t,
        isSafe: Bool,
        tag: String?,
        file: String = #file,
        line: UInt = #line)
    {
        exLogQueue.async {
            os_log("%{public}@", log: ZMSLog.logger(tag: tag), type: level.logLevel, entry.text)
            self.notifyHooks(level: level, tag: tag, entry: entry, isSafe: isSafe)
        }
    }
}

// MARK: - Save on disk & file management
extension ExLog {
    
    @objc static public var currentLog: Data? {
        guard let currentLogPath = self.currentLogPath else { return nil }
        return readFile(at: currentLogPath)
    }

    static private func readFile(at url: URL) -> Data? {
        guard let handle = try? FileHandle(forReadingFrom: url) else { return nil }
        
        try? handle.wr_synchronizeFile()
        
        return handle.readDataToEndOfFile()
    }
    
    @objc static public let currentLogPath: URL? = cachesDirectory?.appendingPathComponent("notification.log")
    
    @objc public static func clearLogs() {
        guard let currentLogPath = currentLogPath else { return }
        exLogQueue.async {
            closeHandle()
            let manager = FileManager.default
            try? manager.removeItem(at: currentLogPath)
        }
    }
    
    
    static var cachesDirectory: URL? {
        guard let groupIdentifier = Bundle.main.infoDictionary?["ApplicationGroupIdentifier"] as? String else {return nil}
        let manager = FileManager.default
        return manager.containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)
    }
    
    static public var pathsForExistingLogs: [URL] {
        var paths: [URL] =  []
        if let currentPath = currentLogPath, currentLog != nil {
            paths.append(currentPath)
        }
        return paths
    }

    static private func closeHandle() {
        updatingHandle?.closeFile()
        updatingHandle = nil
    }

    static func appendToCurrentLog(_ string: String) {
        
        guard let currentLogURL = self.currentLogPath else { return }
        let currentLogPath = currentLogURL.path
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: currentLogPath) {
            manager.createFile(atPath: currentLogPath, contents: nil, attributes: nil)
        }
        
        if updatingHandle == nil {
            updatingHandle = FileHandle(forUpdatingAtPath: currentLogPath)
            updatingHandle?.seekToEndOfFile()
        }
        
        let data = Data(string.utf8)
        
        updatingHandle?.write(data)
    }
}

/// Synchronization queue
let exLogQueue = DispatchQueue(label: "Exlog")
