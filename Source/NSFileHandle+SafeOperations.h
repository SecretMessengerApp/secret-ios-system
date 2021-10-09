//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileHandle (SafeOperations)

/// Attempts to write the data to disk, and safely throws an error in case of failure.
-(BOOL)wr_writeData:(NSData *)data error:(__autoreleasing NSError **)error;

/// Attempts to write the file to disk, and safely throws an error in case of failure.
-(BOOL)wr_synchronizeFile:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END
