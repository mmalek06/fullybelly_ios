import Foundation
import Unbox

struct TACDownloader {
    static func get(tac: @escaping (TermsAndConditions) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getTAC(), success: { (json) in
            guard let result = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                tac(try unbox(dictionary: result))
            } catch let error {
                fail()
                print(error)
            }
        }) { (error) in
            fail()
            print(error)
        }
    }
}
