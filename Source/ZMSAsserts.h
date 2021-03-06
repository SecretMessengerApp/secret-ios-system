// 
// 


#import <Foundation/Foundation.h>

#import <AssertMacros.h>
#import "ZMSDefines.h"

/**
 
 Asserts and checks.
 
 
 There are 3 kinds: Require, Verify, and Check. Require is a _hard_ check that will cause the app to stop / crash if it fails. Verify is graceful by either causing an action or logging a string. Check has no other side effects and are pulled out in production.
 
 Any check that fails will funnel through ZMLogDebugger(). Setting a symbolic breakpoint on that function will cause the debugger to stop on any check failing.
 
 Require(assertion)
 RequireString(assertion, frmt, ...)
 
 VerifyAction(assertion, action)
 VerifyReturn(assertion)
 VerifyReturnValue(assertion, value)
 VerifyReturnNil(assertion)
 VerifyString(assertion, frmt, ...)
 
 Check(assertion)
 CheckNil(obj)
 CheckNotNil(obj)
 CheckString(assertion, frmt, ...)
 
 */


#define ZMTrap() do { \
		ZMCrash("Trap", __FILE__, __LINE__); \
	} while (0)


#if DEBUG_ASSERT_PRODUCTION_CODE

#   define Require(assertion) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Assert", #assertion, __FILE__, __LINE__, nil); \
			ZMCrash(#assertion, __FILE__, __LINE__); \
		} \
	} while (0)

#   define RequireString(assertion, frmt, ...) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Assert", #assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
			ZMCrashFormat(#assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
		} \
	} while (0)

#   define RequireC(assertion) \
		Require(assertion)

#else

#   define Require(assertion) do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMCrash(#assertion, __FILE__, __LINE__); \
		} \
	} while (0)
#   define RequireString(assertion, frmt, ...) do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMCrashFormat(#assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
		} \
	} while (0)
#   define RequireC(assertion) do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMCrash(#assertion, __FILE__, __LINE__); \
		} \
	} while (0)

#endif


#define RequireInternal(assertion, frmt, ...) \
    do { \
        BOOL appStore = [NSBundle.mainBundle.bundleIdentifier isEqualToString:@"com.secrect.qhsj"]; \
        if ( __builtin_expect(!appStore && !(assertion), 0) ) { \
            ZMDebugAssertMessage(@"Assert", #assertion, __FILE__, __LINE__, nil); \
            ZMCrash(#assertion, __FILE__, __LINE__); \
        } \
    } while (0)


#define VerifyAction(assertion, action) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, nil); \
			action; \
		} \
	} while (0)

#define VerifyReturn(assertion) \
	VerifyAction(assertion, return)

#define VerifyReturnValue(assertion, value) \
	VerifyAction(assertion, return (value))

#define VerifyReturnNil(assertion) \
	VerifyAction(assertion, return nil)

#define VerifyString(assertion, frmt, ...) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
		} \
	} while (0)


#define VerifyActionString(assertion, action, frmt, ...) \
    do { \
        if ( __builtin_expect(!(assertion), 0) ) { \
            ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
            action; \
        } \
    } while (0)

#define VerifyStringReturnNil(assertion, frmt, ...) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
			return nil; \
		} \
	} while (0)


#if DEBUG_ASSERT_PRODUCTION_CODE
# define Check(assertion)
#else
# define Check(assertion) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, nil); \
		} \
	} while (0)
#endif

#define CheckNil(value) \
	Check(value == nil)

#define CheckNotNil(value) \
	Check(value != nil)

#if DEBUG_ASSERT_PRODUCTION_CODE
# define CheckString(assertion, frmt, ...)
#else
# define CheckString(assertion, frmt, ...) \
	do { \
		if ( __builtin_expect(!(assertion), 0) ) { \
			ZMDebugAssertMessage(@"Verify", #assertion, __FILE__, __LINE__, frmt, ##__VA_ARGS__); \
		} \
	} while (0)
#endif


#pragma mark -

# define ZMCrash(reason, file, line) \
do { \
    ZMAssertionDump(reason, file, line, nil); \
	__builtin_trap(); \
} while(0)

# define ZMCrashFormat(reason, file, line, format, ...) \
do { \
    ZMAssertionDump(reason, file, line, format, ##__VA_ARGS__); \
	__builtin_trap(); \
} while(0)


#pragma mark - Assert reporting

/// URL of the "last assertion" log file
ZM_EXTERN NSURL* ZMLastAssertionFile(void);
/// Dump a crash to the crash dump file
ZM_EXTERN void ZMAssertionDump(const char * const assertion, const char * const filename, int linenumber, char const *format, ...) __attribute__((format(printf,4,5)));
/// Dump a crash to the crash dump file
ZM_EXTERN void ZMAssertionDump_NSString(NSString *assertion, NSString *filename, int linenumber, NSString *message);
