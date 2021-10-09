// 
// 


import Foundation

/// Reports an error and terminates the application
public func fatal(_ message: String,
                  file: StaticString = #file,
                  line: UInt = #line) -> Never  {
    ZMAssertionDump_NSString("Swift assertion", "\(file)", Int32(line), message)
    fatalError(message, file: file, line: line)
}

/// If the condition is not true, reports an error and terminates the application
public func require(_ condition: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    if(!condition) {
        fatal(message, file: file, line: line)
    }
}

@objc public enum Environment: UInt8 {
    case appStore, `internal`, debug, develop, unknown

    static var current: Environment {
        guard let identifier = Bundle.main.bundleIdentifier else { return .unknown }
        switch identifier {
        case "com.secrect.qhsj": return .appStore
        case "com.secret.alpha": return .debug
        case "com.secret.beta": return .internal
        case "com.secret.development": return .develop
        default: return .unknown
        }
    }

    var isAppStore: Bool {
        return self == .appStore
    }
}

/// Termiantes the application if the condition is `false` and the current build is not an AppsStore build
public func requireInternal(_ condition: Bool, _ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    guard !Environment.current.isAppStore, !condition else { return }
    fatal(message(), file: file, line: line)
}

/// Termiantes the application if the current build is not an AppsStore build
public func requireInternalFailure(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    guard !Environment.current.isAppStore else { return }
    fatal(message(), file: file, line: line)
}
