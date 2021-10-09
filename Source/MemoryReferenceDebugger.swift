//
//

import Foundation


/// This is used to highlight memory leaks of critical objects.
/// In the code, add objects to the debugger by calling `MemoryReferenceDebugger.add`.
/// When running tests, you should check that `MemoryReferenceDebugger.aliveObjects` is empty
@objc public class MemoryReferenceDebugger: NSObject {
    
    public var references = [ReferenceAllocation]()
    
    static private var shared = MemoryReferenceDebugger()
    
    public static func register(_ object: AnyObject?, line: UInt = #line, file: StaticString = #file) {
        register(object, line: line, file: String(describing: file))
    }
    
    @objc public static func register(_ object: NSObject?, line: UInt, file: UnsafePointer<CChar>) {
        let fileString = String.init(cString: file)
        register(object as AnyObject?, line: line, file: fileString)
    }
    
    private static func register(_ object: AnyObject?, line: UInt, file: String) {
        guard let object = object else { return }
        let pointer = Unmanaged<AnyObject>.passUnretained(object).toOpaque()
        shared.references.append(ReferenceAllocation(object: object, pointerAddress: pointer.debugDescription, file: file.description, line: line))
    }
    
    @objc static public func reset() {
        shared.references = []
    }
    
    @objc static public var aliveObjects: [AnyObject] {
        return shared.references.compactMap { $0.object }
    }
    
    @objc static public var aliveObjectsDescription: String {
        return shared.references
            .filter{ $0.object != nil }
            .map{
                $0.description
            }.joined(separator: "\n")
    }
}

public struct ReferenceAllocation: CustomStringConvertible {
    
    public weak var object: AnyObject?
    public let pointerAddress: String
    public let file: String
    public let line: UInt
    
    public var isValid: Bool {
        return self.object != nil
    }
    
    public var description: String {
        guard let object = object else { return "<->" }
        return "\(type(of: object))[\(pointerAddress)], \(self.file):\(self.line)"
    }
    
}
