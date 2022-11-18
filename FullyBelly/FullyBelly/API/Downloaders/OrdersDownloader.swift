import Foundation
import Unbox

struct OrdersDownloader {
    static func get(email: String, sessions: [String], orders: @escaping ([Order]) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getOrdersList(email: email, sessions: sessions), success: { (json) in
            guard let results = json as? [[String: Any]] else {
                fail()
                return
            }
            
            do {
                orders(try unbox(dictionaries: results))
            } catch let error {
                fail()
                print(error)
            }
        }) { (error) in
            fail()
            print(error)
        }
    }
    
    static func get(orderId: String, order: @escaping (Order) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .getOrderMonitor(orderId: orderId), success: { (json) in
            guard let result = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                order(try unbox(dictionary: result))
            } catch let error {
                fail()
                print(error)
            }
        }) { (error) in
            fail()
            print(error)
        }
    }
    
    static func post(bookOrder: BookOrder, order: @escaping (Order) -> Void, fail: @escaping () -> Void) {
        Network.request(target: .postBookOrder(order: bookOrder), success: { (json) in
            guard let result = json as? [String: Any] else {
                fail()
                return
            }
            
            do {
                order(try unbox(dictionary: result))
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
