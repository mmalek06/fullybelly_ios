import Foundation
import Unbox

struct Order {
    let sessionId: String?
    let restaurantName: String?
    let dishesAmount: Int?
    let pickupTime: String?
    let number: String?
}

extension Order: Unboxable {
    init(unboxer: Unboxer) throws {
        self.sessionId = unboxer.unbox(key: "session_id")
        self.restaurantName = unboxer.unbox(key: "restaurant_name")
        self.dishesAmount = unboxer.unbox(key: "dishes_amount")
        self.pickupTime = unboxer.unbox(key: "pickup_time")
        self.number = unboxer.unbox(key: "number")
    }
}
