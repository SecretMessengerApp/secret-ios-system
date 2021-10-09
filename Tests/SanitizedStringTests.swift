////
//

import Foundation


import XCTest
@testable import WireSystem

struct Item {
    var name: String
    var age: Int
}

extension Item: SafeForLoggingStringConvertible {
    static var redacted = "<redacted>"
    
    var safeForLoggingDescription: String {
        return Item.redacted
    }
}


class SanitizedStringTests: XCTestCase {
    
    var item: Item!
    
    override func setUp() {
        super.setUp()
        item = Item(name: "top-secret", age: 99)
    }
    
    override func tearDown() {
        item = nil
        super.tearDown()
    }
    
    func testInterpolation() {
        let interpolated: SanitizedString = "\(item)"
        let redacted: SanitizedString = "<redacted>"
        XCTAssertEqual(redacted, interpolated)
    }
    
    func testInterpolationWithLiterals() {
        let interpolated: SanitizedString = "some \(item) item"
        let result = SanitizedString(stringLiteral: "some \(Item.redacted) item")
        XCTAssertEqual(result, interpolated)
    }
}

extension SanitizedStringTests {
    func testString() {
        let sut = "some"
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        XCTAssertEqual(sut, result.value)
    }
    
    func testInt() {
        let sut = 12
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        XCTAssertEqual(String(sut), result.value)
    }
    
    func testFloat() {
        let sut: Float = 12.1
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        XCTAssertEqual(String(sut), result.value)
    }
    
    func testDouble() {
        let sut: Double = 12.1
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        XCTAssertEqual(String(sut), result.value)
    }
    
    func testArray() {
        let sut = [1, 2, 3]
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        XCTAssertEqual(String(describing: sut), result.value)
    }
    
    func testDictionary() {
        let sut = ["some" : 2]
        let value = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        
        XCTAssertEqual(String(describing: sut), result.value)
    }
    
    func testOptional_nil() {
        let value: SafeValueForLogging<String>? = nil
        let result: SanitizedString = "\(value)"
        XCTAssertEqual("nil", result.value)
    }
    
    func testOptional_notNil() {
        let sut = "something"
        let value: SafeValueForLogging<String>? = SafeValueForLogging(sut)
        let result: SanitizedString = "\(value)"
        
        XCTAssertEqual(String(describing: sut), result.value)
    }
}
