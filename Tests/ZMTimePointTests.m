// 
// 


#import <XCTest/XCTest.h>
#import "ZMSTimePoint.h"

@interface ZMTimePointTests : XCTestCase

@end

@implementation ZMTimePointTests

- (void)testThatATimePointDoesNotWarnTooEarly
{
    // given
    ZMSTimePoint *tp = [ZMSTimePoint timePointWithInterval:1000];
    
    // then
    XCTAssertFalse([tp warnIfLongerThanInterval]);
}

- (void)testThatATimePointWarnsIfTooMuchTimeHasPassed
{
    // given
    ZMSTimePoint *tp = [ZMSTimePoint timePointWithInterval:0.01];
    
    // when
    [NSThread sleepForTimeInterval:0.1];
    
    // then
    XCTAssertTrue([tp warnIfLongerThanInterval]);
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}

@end
