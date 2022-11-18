import Foundation
import Unbox

struct Configuration: Unboxable {
    var p24CRC: String? // P24
    var p24MerchantId: Int? // P24
    var token: String? // BrainTree
    
    init(unboxer: Unboxer) throws {
        p24CRC = unboxer.unbox(key: "P_24_CRC")
        p24MerchantId = unboxer.unbox(key: "P_24_MERCHANT")
        token = unboxer.unbox(key: "token")
    }
}
