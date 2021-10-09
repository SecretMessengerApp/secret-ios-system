// 
// 


#import <Foundation/Foundation.h>

@interface ZMSDispatchGroup : NSObject

@property (nonatomic, readonly, copy) NSString* label;

+ (instancetype)groupWithLabel:(NSString *)label;
+ (instancetype)groupWithDispatchGroup:(dispatch_group_t)group label:(NSString *)label;

- (void)enter;
- (void)leave;
- (void)notifyOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block;
- (long)waitWithTimeout:(dispatch_time_t)timeout;
- (long)waitForInterval:(NSTimeInterval)timeout;
- (void)asyncOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block;

@end
