//
//

import Foundation
import os.log

// MARK: - Log level management

/// Map of the level set for each log tag
private var logTagToLevel : [String : ZMLogLevel_t] = [:]
private var logTagToLogger : [String : OSLog] = [:]

@objc extension ZMSLog {
    
    /// Sets the minimum logging level for the tag
    /// - note: switches to the log queue
    public static func set(level: ZMLogLevel_t, tag: String) {
        logQueue.sync {
            logTagToLevel[tag] = level
        }
    }
    
    /// Gets the minimum logging level for the tag
    /// - note: switches to the log queue
    public static func getLevel(tag: String) -> ZMLogLevel_t {
        var level = ZMLogLevel_t.warn
        logQueue.sync {
            level = getLevelNoLock(tag: tag)
        }
        return level
    }
    
    /// Gets the minimum logging level for the tag
    /// - note: Does not switch to the log queue
    static func getLevelNoLock(tag: String) -> ZMLogLevel_t {
        return logTagToLevel[tag] ?? .warn
    }
    
    /// Registers a tag for logging
    /// - note: Does not switch to the log queue
    static func register(tag: String) {
        if logTagToLevel[tag] == nil {
            logTagToLevel[tag] = ZMLogLevel_t.warn
        }
    }

    @available(iOS 10, *)
    static func logger(tag: String?) -> OSLog {
        guard let tag = tag else { return OSLog.default }
        if logTagToLogger[tag] == nil {
            let bundleID = Bundle.main.bundleIdentifier ?? "com.wire.zmessaging.test"
            let logger = OSLog(subsystem: bundleID, category: tag)
            logTagToLogger[tag] = logger
        }
        return logTagToLogger[tag]!
    }
    
    /// Get all tags
    public static var allTags : [String] {
        var tags : [String] = []
        logQueue.sync {
            tags = Array(logTagToLevel.keys)
        }
        return tags
    }
}

// MARK: - Debugging
extension ZMSLog {
    
    static func debug_resetAllLevels() {
        logQueue.sync {
            logTagToLevel = [:]
        }
    }
    
}
