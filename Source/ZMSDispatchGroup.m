// 
// 


#import "ZMSDispatchGroup.h"

@interface ZMSDispatchGroup ()

@property (nonatomic, copy) NSString* label;
@property (nonatomic) dispatch_group_t group;

@end



@implementation ZMSDispatchGroup

+ (instancetype)groupWithDispatchGroup:(dispatch_group_t)group label:(NSString *)label;
{
    return [[ZMSDispatchGroup alloc] initWithGroup:group label:label];
}

- (instancetype)initWithGroup:(dispatch_group_t)group label:(NSString *)label;
{
    self = [super init];
    if(self) {
        self.label = label;
        self.group = group;
    }
    return self;
}

+ (instancetype)groupWithLabel:(NSString *)label
{
    return [[ZMSDispatchGroup alloc] initWithGroup:dispatch_group_create() label:label];
}

- (long)waitWithTimeout:(dispatch_time_t)timeout
{
    return dispatch_group_wait(self.group, timeout);
}

- (long)waitForInterval:(NSTimeInterval)timeout;
{
    dispatch_time_t start = DISPATCH_TIME_NOW;
    int64_t delta = ((int64_t)(timeout) * 1000) * (int64_t)NSEC_PER_MSEC;
    return dispatch_group_wait(self.group, dispatch_time(start, delta));
}

- (void)enter
{
    dispatch_group_enter(self.group);
}

- (void)leave
{
    dispatch_group_leave(self.group);
}

- (void)notifyOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_group_notify(self.group, queue, block);
}

- (void)asyncOnQueue:(dispatch_queue_t)queue block:(dispatch_block_t)block
{
    dispatch_group_async(self.group, queue, block);
}

@end
