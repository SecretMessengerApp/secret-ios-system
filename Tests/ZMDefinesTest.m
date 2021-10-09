// 
// 


@import WireSystem;
@import XCTest;

@interface ZMDefinesTest : XCTestCase

@end

@implementation ZMDefinesTest


- (void)testThat_Requires_Compiles {
    Require(YES);
    RequireString(YES, "Foo %d", 12);
}

- (void)testThat_VerifyReturns_ReturnsOnFailure {
    
    // given
    __block BOOL called = false;
    dispatch_block_t testBlock = ^{
        VerifyReturn(false);
        called = true;
    };
    
    // when
    testBlock();
    
    // then
    XCTAssertFalse(called);
}

- (void)testThat_VerifyReturns_ReturnsOnSuccess {
    
    // given
    __block BOOL called = false;
    dispatch_block_t testBlock = ^{
        VerifyReturn(true);
        called = true;
    };
    
    // when
    testBlock();
    
    // then
    XCTAssert(called);
}

- (void)testThat_VerifyReturnNil_ReturnsOnFailure {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyReturnNil(false);
        return @"Foo";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertNil(result);
}

- (void)testThat_VerifyReturnNil_ReturnsOnSuccess {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyReturnNil(true);
        return @"Foo";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Foo");
}

- (void)testThat_VerifyReturnValue_ReturnsOnFailure {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyReturnValue(false, @"Fail");
        return @"Success";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Fail");
}

- (void)testThat_VerifyReturnValue_ReturnsOnSuccess {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyReturnValue(true, @"Fail");
        return @"Success";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Success");
}

- (void)testThat_VerifyReturnAction_Failure {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyAction(false, return @"Fail");
        return @"Success";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Fail");
}

- (void)testThat_VerifyReturnAction_Success {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyAction(true, return @"Fail");
        return @"Success";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Success");
}

- (void)testThat_VerifyString_compiles {
    
    VerifyString(false, "Foo %d", 12);
    VerifyString(true, "Foo %d", 12);
}

- (void)testThat_VerifyStringReturnNil_ReturnsOnFailure {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyStringReturnNil(false, "Foo %d", 12);
        return @"Foo";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertNil(result);
}

- (void)testThat_VerifyStringReturnNil_ReturnsOnSuccess {
    
    // given
    NSString*(^testBlock)(void) = ^NSString *(){
        VerifyStringReturnNil(true, "Foo %d", 12);
        return @"Foo";
    };
    
    // when
    NSString *result = testBlock();
    
    // then
    XCTAssertEqualObjects(result, @"Foo");
}

@end
