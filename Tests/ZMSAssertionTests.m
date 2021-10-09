// 
// 


#import <XCTest/XCTest.h>
#import <WireSystem/WireSystem.h>

@interface ZMSAssertionTests : XCTestCase

@end

@implementation ZMSAssertionTests

- (void)setUp {
    [super setUp];
    [[NSFileManager defaultManager] removeItemAtURL:ZMLastAssertionFile() error:nil];
}

- (void)tearDown {
    [[NSFileManager defaultManager] removeItemAtURL:ZMLastAssertionFile() error:nil];
    [super tearDown];
}

- (void)testThatItDumpToCrashFile {
    
    // given
    NSString *expected = @"ASSERT: [printer.c:234] <lp0 != 0> lp0 on fire";
    
    // when
    ZMAssertionDump("lp0 != 0", "printer.c", 234, "lp%d on fire", 0);
    
    // then
    NSString *dump = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:ZMLastAssertionFile()] encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(dump, expected);
}

@end
