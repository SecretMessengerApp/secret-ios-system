//
//

import Foundation

extension DispatchQueue {
    public func async(group: ZMSDispatchGroup?, execute:@escaping  () -> Void) {
        group?.enter()
        async {
            execute()
            group?.leave()
        }
    }
}
