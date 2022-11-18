import Foundation
import Unbox

struct Transaction {
    let transactionSuccessful: Bool
    let sessionId: String
    let validations: [String]?
}

extension Transaction: Unboxable {
    init(unboxer: Unboxer) throws {
        self.transactionSuccessful = try unboxer.unbox(key: "transaction_successful")
        self.sessionId = try unboxer.unbox(key: "session_id")
        self.validations = unboxer.unbox(key: "validations")
    }
}
