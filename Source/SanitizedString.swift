////
//

import Foundation

public struct SanitizedString: Equatable {
    var value: String
}

extension SanitizedString: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }
}

extension SanitizedString: ExpressibleByStringInterpolation {
    public init(stringInterpolation: SanitizedString) {
        self.value = stringInterpolation.value
    }
}

extension SanitizedString: StringInterpolationProtocol {
    
    public init(literalCapacity: Int, interpolationCount: Int) {
        self.value = ""
    }
    
    public mutating func appendLiteral(_ literal: StringLiteralType) {
        value += literal
    }
    
    public mutating func appendInterpolation<T: SafeForLoggingStringConvertible>(_ x: T?) {
        value += x?.safeForLoggingDescription ?? "nil"
    }
}

extension SanitizedString: CustomStringConvertible {
    public var description: String {
        return value
    }
}
