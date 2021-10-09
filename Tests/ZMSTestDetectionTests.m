// 
// 


#import <XCTest/XCTest.h>
#import "ZMSTestDetection.h"

@interface ZMSTestDetectionTests : XCTestCase

@property (nonatomic) BOOL testVariableWasOn;

@end

@implementation ZMSTestDetectionTests

- (void)setUp {
    char *var = getenv(zm_testing_environment_variable_name.UTF8String);
    self.testVariableWasOn = var != 0 && strcmp(var, "1") == 0;
}

- (void)tearDown {
    setenv(zm_testing_environment_variable_name.UTF8String, self.testVariableWasOn ? "1" : "0", 1);
}


- (void)testThatItIsNotInATestWhenTheEnvironmentVariableIsOff {
    
    XCTAssertFalse(zm_isTesting());
}

- (void)testThatItIsInATestWhenTheEnvironmentVariableIsOn {

    setenv(zm_testing_environment_variable_name.UTF8String, "1", 1);
    XCTAssertTrue(zm_isTesting());
}

@end
