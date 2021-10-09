//
//

import Foundation

private var recordingToken : LogHookToken? = nil

extension ExLog {
    
    /// Start recording
    @objc public static func startRecording(isInternal: Bool = true) {
        exLogQueue.sync {
            if recordingToken == nil {
                recordingToken = self.nonLockingAddEntryHook(logHook: { (level, tag, entry, isSafe) -> (Void) in
                    guard isInternal || isSafe else { return }
                    let tagString = tag.flatMap { "[\($0)] "} ?? ""
                    let date = dateFormatter.string(from: entry.timestamp)
                    // Add newline if it does not have it yet
                    let text = entry.text.hasSuffix("\n") ? entry.text : entry.text + "\n"
                    ExLog.appendToCurrentLog("\(date): [\(level.rawValue)] \(tagString)\(text)")
                })
            }
        }
    }
    
    /// Stop recording logs and discard cache
    @objc public static func stopRecording() {
        var tokenToRemove : LogHookToken?
        exLogQueue.sync {
            guard let token = recordingToken else { return }
            tokenToRemove = token
            ExLog.clearLogs()
            recordingToken = nil
        }
        if let token = tokenToRemove {
            self.removeLogHook(token: token)
        }
    }

    private static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS Z"
        return df
    }()
    
    private static var isRunningSystemTests: Bool {
        guard let path = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"]
            else { return false }
        return path.contains("WireSystem Tests")
    }
    
}
