// 
// 


#import <Foundation/Foundation.h>

FOUNDATION_EXPORT const NSString * const zm_testing_environment_variable_name;

/// Returns true when the code is being executed in a testing environment.
/// In order for this to work, the "ZM_TESTING" enviroment variable must be set to 1 in the test target
FOUNDATION_EXPORT BOOL zm_isTesting(void);
