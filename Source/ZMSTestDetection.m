// 
// 


#import "ZMSTestDetection.h"

NSString * const zm_testing_environment_variable_name = @"ZM_TESTING";


BOOL zm_isTesting(void) {
    
    NSString *value = [NSProcessInfo processInfo].environment[zm_testing_environment_variable_name];
    return value != nil && [value isEqualToString:@"1"];
}
