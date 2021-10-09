//
//

import XCTest
@testable import WireSystem

class CircularArrayTests : XCTestCase {
    
    func testThatItReturnsContentWhenNotWrapping() {
        
        // GIVEN
        var sut = CircularArray<String>(size: 5)
        
        // WHEN
        sut.add("A")
        sut.add("B")
        
        // THEN
        XCTAssertEqual(sut.content, ["A", "B"])
    }
    
    func testThatItReturnsContentWhenWrapping() {
        
        // GIVEN
        var sut = CircularArray<Int>(size: 3)
        
        // WHEN
        sut.add(1)
        sut.add(2)
        sut.add(3)
        sut.add(4)
        sut.add(5)
        sut.add(6)
        
        // THEN
        XCTAssertEqual(sut.content, [4,5,6])
    }
}
