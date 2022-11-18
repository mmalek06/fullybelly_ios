import Foundation
import Unbox

struct OffersDownloader {
    static func get(query: String?, params: OffersParameters?, pagination: Pagination?, offers: @escaping ([Offer], Int?) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getOffers(query: query, offerParameters: params, pagination: pagination), success: { (json) in
            guard let json = json as? [String: Any],
                let results = json["results"] as? [[String: Any]] else {
                fail()
                return
            }
            
            do {
                offers(try unbox(dictionaries: results), json["count"] as? Int)
            } catch let error {
                fail()
                print(error)
            }
        }) { (error) in
            fail()
            print(error)
        }
    }
    
    static func get(restaurantId: Int, offerId: Int?, offer: @escaping (Offer) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getOfferDetail(resturantId: restaurantId, offerId: offerId), success: { (json) in
            guard let result = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                offer(try unbox(dictionary: result))
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
