import Foundation
import Unbox

struct CheckoutDownloader {
    static func checkout(nonce: String, sessionId: String, transaction: @escaping (Transaction) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .postCheckout(nonce: nonce, sessionId: sessionId), success: { (json) in
            guard let result = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                transaction(try unbox(dictionary: result))
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
