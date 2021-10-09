// 
// 


#import <XCTest/XCTest.h>
#import <WireSystem/WireSystem.h>

static NSString* ZMLogTag = @"Testing";

@interface ZMLoggingTests : XCTestCase
@end

@implementation ZMLoggingTests

- (void)testThatLogMacrosCompile    
{
    ZMLogError(@"Test");
    ZMLogWarn(@"Test");
    ZMLogInfo(@"Test");
    ZMLogDebug(@"Test");
}

@end
