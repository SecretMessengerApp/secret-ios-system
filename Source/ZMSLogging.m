// 
// 


#import "ZMSLogging.h"
#import "WireSystem/WireSystem-swift.h"

void ZMLog(NSString *tag, char const * const filename, int linenumber, ZMLogLevel_t logLevel, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *output = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    [ZMSLog logWithLevel:logLevel message:^NSString * _Nonnull{
        return output;
    } tag:tag file:[NSString stringWithUTF8String:filename] line:(NSUInteger)linenumber];
}

void ZMDebugAssertMessage(NSString *tag, char const * const assertion, char const * const filename, int linenumber, char const * const format, ...)
{
    char * message = NULL;
    va_list ap;
    va_start(ap, format);
    if ((format == NULL) || (vasprintf(&message, format, ap) == 0)) {
        message = NULL;
    }
    va_end(ap);
    
    NSString *output = [NSString stringWithFormat:@"Assertion (%s) failed. %s", assertion, message ?: ""];
    [ZMSLog logWithLevel:ZMLogLevelError message:^NSString * _Nonnull{
        return output;
    } tag:tag file:[NSString stringWithUTF8String:filename] line:(NSUInteger)linenumber];
}

