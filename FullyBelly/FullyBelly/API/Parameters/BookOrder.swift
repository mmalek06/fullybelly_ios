import Foundation
import Wrap

struct BookOrder: WrapCustomizable {
    let restaurant: Int
    var email: String
    let meal: Int
    let amount: Int
    var paymentMethod: PaymentMethod?
    
    func keyForWrapping(propertyNamed propertyName: String) -> String? {
        switch propertyName {
        case "email":
            return "buyer_email"
        default:
            break
        }
        
        return propertyName
    }
}
