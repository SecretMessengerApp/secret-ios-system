//
//

#import "NSFileHandle+SafeOperations.h"

@implementation NSFileHandle (SafeOperations)

-(BOOL)wr_writeData:(NSData *)data error:(__autoreleasing NSError **)error
{
    @try {
        [self writeData:data];
        return YES;
    } @catch(NSException *exception) {
        *error = [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

-(BOOL)wr_synchronizeFile:(NSError * _Nullable __autoreleasing *)error
{
    @try {
        [self synchronizeFile];
        return YES;
    } @catch(NSException *exception) {
        *error = [NSError errorWithDomain:exception.name code:0 userInfo:exception.userInfo];
        return NO;
    }
}

@end
