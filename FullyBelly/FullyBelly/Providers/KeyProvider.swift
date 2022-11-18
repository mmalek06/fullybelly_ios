import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
    static let TACUserAccepted = DefaultsKey<Bool?>("TACUserAccepted")
    static let TACAcceptedVersion = DefaultsKey<Int?>("TACAcceptedVersion")
    static let favorites = DefaultsKey<[Int]>("favorites")
    static let lastOffersParameters = DefaultsKey<OffersParameters?>("lastOffersParameters")
    static let email = DefaultsKey<String?>("email")
    static let monitoredSessionId = DefaultsKey<String?>("monitoredSessionId")
    static let confirmedSessionIds = DefaultsKey<[String: Any]?>("confirmedSessionIds")
    static let paymentMethod = DefaultsKey<PaymentMethod?>("paymentMethod")
    static let visitedOrders = DefaultsKey<[String]>("visitedOrders")
}

enum PaymentMethod: Int {
    case credit
    case transfer
}

extension UserDefaults {
    subscript(key: DefaultsKey<OffersParameters?>) -> OffersParameters? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }

    subscript(key: DefaultsKey<PaymentMethod?>) -> PaymentMethod? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
