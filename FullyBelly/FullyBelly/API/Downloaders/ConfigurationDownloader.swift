import Foundation
import Unbox

struct ConfigurationDownloader {
    static func get(configuration: @escaping (Configuration) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getConfiguration(), success: { (json) in
            guard let results = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                configuration(try unbox(dictionary: results))
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
