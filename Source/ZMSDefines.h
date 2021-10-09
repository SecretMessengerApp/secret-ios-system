// 
// 



#ifndef ZM_EXTERN
#  define ZM_EXTERN FOUNDATION_EXTERN
#endif


#define ZM_UNUSED __attribute__((unused))
#define NOT_USED(x) do { (void)(x); } while (0)
#define ZM_REQUIRES_SUPER __attribute__((objc_requires_super))
#define ZM_NON_NULL(x, ...) __attribute__((nonnull(x, ##__VA_ARGS__)))
#define ZM_MUST_USE_RETURN __attribute__((warn_unused_result))
#if __has_extension(attribute_deprecated_with_message)
# define ZM_DEPRECATED(message) __attribute__((deprecated(message)))
#else
#define ZM_DEPRECATED(message) __attribute__((deprecated))
#endif

#ifdef TEST_TARGET
# define ZM_TEST_ONLY_HEADER
#else
# define ZM_TEST_ONLY_HEADER  _Pragma("GCC error (\"This header file should only be included in tests.\")")
#endif

/// @def ZM_WEAK
/// Helper to make a variable @c __weak before passing into a block. Use like so:
/// @code
/// ZM_WEAK(self);
/// [foo runWithHandler:^(){
///     ZM_STRONG(self);
///     [self markAsDone];
/// }];
/// @endcode
#define ZM_WEAK(a) \
	__weak typeof(a) weak_ ## a = a

#define ZM_STRONG(a) \
	_Pragma("clang diagnostic push") \
	_Pragma("clang diagnostic ignored \"-Wshadow\"") \
	__strong typeof(weak_ ## a) a = weak_ ## a; \
	_Pragma("clang diagnostic pop") \
	(void) a

#define ZM_EMPTY_IMPLEMENTATION(func) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wunused-parameter\"") \
    func {} \
	_Pragma("clang diagnostic pop")

#define ZM_SILENCE_CALL_TO_UNKNOWN_SELECTOR(func) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    func \
	_Pragma("clang diagnostic pop")

#define ZM_ALLOW_MISSING_SELECTOR(func) \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wselector\"") \
    func \
	_Pragma("clang diagnostic pop")

#define ZM_EMPTY_ASSERTING_INIT() \
	_Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wobjc-designated-initializers\"") \
	- (instancetype)init; \
	{ \
        Require(NO); \
        return nil; \
	} \
	_Pragma("clang diagnostic pop")

#define ZM_ALLOW_DEPRECATED(func) \
	_Pragma("clang diagnostic push") \
	_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
	func \
	_Pragma("clang diagnostic pop")

#define ZMLocalizedString(key) \
	[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"ZMLocalizable"]

