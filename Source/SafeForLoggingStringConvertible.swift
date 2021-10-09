////
//

import Foundation

/// Object can implement this protocol to allow creating the privacy-enabled object description.
/// Things to consider when implementing is to exclude any kind of personal information from the object description:
/// No user name, login, email, etc., or any kind of backend object ID.
public protocol SafeForLoggingStringConvertible {
    var safeForLoggingDescription: String { get }
}

public struct SafeValueForLogging<T: CustomStringConvertible>: SafeForLoggingStringConvertible {
    public let value: T
    public init(_ value: T) {
        self.value = value
    }
    public var safeForLoggingDescription: String {
        return value.description
    }
}

extension Array: SafeForLoggingStringConvertible where Array.Element: SafeForLoggingStringConvertible {
    public var safeForLoggingDescription: String {
        return String(describing: map { $0.safeForLoggingDescription} )
    }
}

extension Dictionary: SafeForLoggingStringConvertible where Key: SafeForLoggingStringConvertible, Value: SafeForLoggingStringConvertible {
    public var safeForLoggingDescription: String {
        let result = enumerated().map { (_, element) in
            return (element.key.safeForLoggingDescription, element.value.safeForLoggingDescription)
        }
        
        let dictionary = Dictionary<String, String>(uniqueKeysWithValues: result)
        return String(describing: dictionary)
    }
}
