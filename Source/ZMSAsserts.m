// 
// 


#import <Foundation/Foundation.h>
#import "ZMSAsserts.h"

void ZMAssertionDump_NSString(NSString *assertion, NSString *filename, int linenumber, NSString *message) {
    ZMAssertionDump(assertion.UTF8String, filename.UTF8String, linenumber, "%s", message.UTF8String);
}

void ZMAssertionDump(const char * const assertion, const char * const filename, int linenumber, char const * const format, ...) {

    // prepare content
    char * message = NULL;
    va_list ap;
    va_start(ap, format);
    if ((format == NULL) || (vasprintf(&message, format, ap) == 0)) {
        message = NULL;
    }
    va_end(ap);
    NSString *output = [NSString stringWithFormat:@"ASSERT: [%s:%d] <%s> %s",
                        filename ? filename : "",
                        linenumber,
                        assertion ? assertion : "",
                        message ? message : ""];
    
    // prepare file and exclude from backup
    NSURL *dumpFile = ZMLastAssertionFile();
    [[NSData data] writeToURL:dumpFile atomically:NO];
    [dumpFile setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    // dump to file
    [[output dataUsingEncoding:NSUTF8StringEncoding] writeToURL:dumpFile atomically:YES];
}

NSURL* ZMLastAssertionFile() {
    
    NSURL* appSupportDir = [[NSFileManager defaultManager]
                            URLForDirectory:NSApplicationSupportDirectory
                            inDomain:NSUserDomainMask
                            appropriateForURL:nil
                            create:YES
                            error:nil];
    
    return [appSupportDir URLByAppendingPathComponent:@"last_assertion.log"];
}
