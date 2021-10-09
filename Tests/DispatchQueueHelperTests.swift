//
//

import XCTest
import WireSystem

class DispatchQueueHelperTests: XCTestCase {
    func testThatItEntersAndLeavesADispatchGroup() {
        // Given
        let group = ZMSDispatchGroup(label: name)
        let queue = DispatchQueue(label: name)
        let groupExpectation = expectation(description: "It should leave the group")
        var result = 0
        
        // When
        queue.async(group: group) {
            result = 42
        }
        
        // Then
        group?.notify(on: .main) {
            XCTAssertEqual(result, 42)
            groupExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
