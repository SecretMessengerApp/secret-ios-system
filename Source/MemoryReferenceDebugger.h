//
//

/// This is used to highlight memory leaks of critical objects.
/// In the code, add objects to the debugger by calling `MemoryReferenceDebugger.add`.
/// When running tests, you should check that `MemoryReferenceDebugger.aliveObjects` is empty
#define RecordReferenceForDebugging(ref) \
    [MemoryReferenceDebugger register:ref line:__LINE__ file:__FILE__];

