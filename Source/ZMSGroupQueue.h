// 
// 


@class ZMSDispatchGroup;

/// Similar to a dispatch queue or NSOperationQueue
@protocol ZMSGroupQueue <NSObject>

/// Submits a block to the receiver's private queue and associates it with the
/// receiver's group.
///
/// This will use @c -performBlock: internally and hence encapsulates
/// an autorelease pool and a call to @c -processPendingChanges
///
/// @sa -performBlock:
- (void)performGroupedBlock:(dispatch_block_t)block ZM_NON_NULL(1);

/// The underlying dispatch group that is used for @c -performGroupedBlock:
///
/// It can be used to associate a block with the receiver without running it on the
/// receiver's queue.
@property (nonatomic, readonly) ZMSDispatchGroup *dispatchGroup;

@end
