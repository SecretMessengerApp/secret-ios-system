// 
// 


#import <Foundation/Foundation.h>
#import <WireSystem/ZMSAsserts.h>

/// Log levels
typedef NS_ENUM(int8_t, ZMLogLevel_t) {
    ZMLogLevelPublic = 0,
    ZMLogLevelError,
    ZMLogLevelWarn,
    ZMLogLevelInfo,
    ZMLogLevelDebug,
};


/**
 
 Logging
 
 
 This is for zmessaging logging.
 
 
 How to use:
 
 At the top of the file define the log level like so:
 
 @code
 static NSString* ZMLogTag ZM_UNUSED = "Network";
 @endcode
 
 The @c ZMLogError() etc. then work just like @c NSLog() does.
 
 
 You can set a (symbolic) breakpoint at ZMLogDebugger to stop automatically when a warning or error level message is logged.
 
 **/
#define ZMLogPublic(format, ...) ZMLogWithLevelAndTag(ZMLogLevelPublic, ZMLogTag, format, ##__VA_ARGS__)
#define ZMLogError(format, ...) ZMLogWithLevel(ZMLogLevelError, format, ##__VA_ARGS__)
#define ZMLogWarn(format, ...) ZMLogWithLevel(ZMLogLevelWarn, format, ##__VA_ARGS__)
#define ZMLogInfo(format, ...) ZMLogWithLevelAndTag(ZMLogLevelInfo, ZMLogTag, format, ##__VA_ARGS__)
#define ZMLogDebug(format, ...) ZMLogWithLevelAndTag(ZMLogLevelDebug, ZMLogTag, format, ##__VA_ARGS__)


#define ZMLogWithLevelAndTag(level, tag, format, ...) \
    do { \
        ZMLog(tag, __FILE__, __LINE__, level, format, ##__VA_ARGS__); \
    } while (0)

#define ZMLogWithLevel(level, format, ...) \
    do { \
        ZMLog(0, __FILE__, __LINE__, level, format, ##__VA_ARGS__); \
    } while (0)

/// Logs an assert
ZM_EXTERN void ZMDebugAssertMessage(NSString *tag, char const * const assertion, char const * const filename, int linenumber, char const *format, ...) __attribute__((format(printf,5,6)));
/// Logs a message
ZM_EXTERN void ZMLog(NSString *tag, char const * const filename, int linenumber, ZMLogLevel_t logLevel, NSString *format, ...) NS_FORMAT_FUNCTION(5,6);
