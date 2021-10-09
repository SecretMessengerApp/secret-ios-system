//
//

#import <XCTest/XCTest.h>
@import WireSystem;

@interface MemoryReferenceDebuggerObjcTests : XCTestCase

@end

@implementation MemoryReferenceDebuggerObjcTests


- (void)testThatItDetectsObjectsThatAreStillAlive {
    
    // GIVEN
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.wire.com"];
    
    // WHEN
    RecordReferenceForDebugging(url);
    
    // THEN
    XCTAssertEqual([MemoryReferenceDebugger aliveObjects].count, 1u);
    
}

- (void)testThatItFiltersOutObjectsThatAreNotAlive {
    
    // GIVEN
    NSURL *url = [[NSURL alloc] initWithString:@"https://www.wire.com"];
    
    // WHEN
    RecordReferenceForDebugging(url);
    url = nil;
    
    // THEN
    XCTAssertEqual([MemoryReferenceDebugger aliveObjects].count, 0u);
    
}

@end
