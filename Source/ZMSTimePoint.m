// 
// 


#import "ZMSTimePoint.h"
#import "ZMSLogging.h"

@interface ZMSTimePoint ()

@property (nonatomic) NSTimeInterval warnInterval;
@property (nonatomic) NSArray<NSString *> *callstack;
@property (nonatomic) NSDate *timePoint;
@property (nonatomic) NSString *label;

@end


@implementation ZMSTimePoint

+ (BOOL)timePointEnabled {
    return NSProcessInfo.processInfo.environment[@"ZM_TIMEPOINTS_CALLSTACK"].boolValue;
}

+ (instancetype)timePointWithInterval:(NSTimeInterval)interval label:(NSString *)label {

    ZMSTimePoint *tp = [[ZMSTimePoint alloc] init];
    if([self timePointEnabled]) {
        tp.callstack = [self filteredCallstack];
    }
    tp.warnInterval = interval;
    tp.timePoint = [NSDate date];
    tp.label = label;
    return tp;
}

/// Returns the current callstack, minus entry relative to this class
+ (NSArray<NSString *>*)filteredCallstack {
    
    NSArray *callstack = [NSThread callStackSymbols];
    NSString *thisClassStaticMethod = [NSString stringWithFormat:@"+[%@ ", self];
    NSMutableArray *finalArray = [NSMutableArray array];
    [callstack enumerateObjectsUsingBlock:^(NSString*  _Nonnull entry, NSUInteger __unused idx, BOOL * _Nonnull __unused stop) {
        if(![entry containsString:thisClassStaticMethod]) {
            [finalArray addObject:entry];
        }
    }];
    return finalArray;
}

+ (instancetype)timePointWithInterval:(NSTimeInterval)interval {
    return [self timePointWithInterval:interval label:nil];
}

- (void)resetTime {
    self.timePoint = [NSDate date];
}


- (NSTimeInterval)elapsedTime {
    return - [self.timePoint timeIntervalSinceNow];
}

- (BOOL)warnIfLongerThanInterval {
    NSTimeInterval now = [self elapsedTime];
    if(now > self.warnInterval && [[self class] timePointEnabled]) {
        ZMLogWarn(@"Time point (%@) warning threshold: %@ seconds elapsed\nCall stack:\n%@", self.label, @(now), [self.callstack componentsJoinedByString:@"\n"]);
    }
    return now > self.warnInterval;
}

@end
