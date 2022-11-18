import Moya
import Wrap
import Alamofire

enum FullyBellyService {
    case getConfiguration()
    case getTAC()
    case getOffers(query: String?, offerParameters: OffersParameters?, pagination: Pagination?)
    case getOfferDetail(resturantId: Int, offerId: Int?)
    case getOrderMonitor(orderId: String)
    case getOrdersList(email: String, sessions: [String])
    case postBookOrder(order: BookOrder)
    case postCheckout(nonce: String, sessionId: String)
    case p24Status()
}

extension FullyBellyService: TargetType {
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .postBookOrder(_), .postCheckout(_, _):
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    #if DEBUG
    var baseURL: URL { return URL(string: "https://api.test.fullybelly.pl/v1")! }
    #else
    var baseURL: URL { return URL(string: "https://api.fullybelly.pl/v1")! }
    #endif
    
    var path: String {
        switch self {
        case .getConfiguration():
            var configuration = "/payments/"
            if let region = NSLocale.current.regionCode?.lowercased(), region == "pl" {
                configuration = configuration + "configuration-p24/"
            } else {
                configuration = configuration + "configuration-bt/" + (NSLocale.current.regionCode?.lowercased() ?? "en") + "/"
            }
            return configuration
        case .getTAC():
            return "/terms-and-conditions/\(NSLocale.current.regionCode?.lowercased() ?? "en")/"
        case .getOffers(let query, _, let pagination):
            var offerPath = "/offers/" + locationPath()
                
            if let query = query, !query.isEmpty {
                offerPath = offerPath + "/" + query.urlEscaped
            }
            
            if let pagination = pagination {
                let limit: String? = pagination.limit != nil ? "limit=" + String(pagination.limit!) : nil
                let offset: String? = pagination.offset != nil ? "offset=" + String(pagination.offset!) : nil

                offerPath = offerPath + "/?" + [limit, offset].flatMap({$0}).joined(separator: "&")
            }
            return offerPath
        case .getOfferDetail(let resturantId, let offerId):
            return "/offers/detail/" + locationPath() + "/" + String(resturantId) + "/" + String(offerId ?? 0)
        case .getOrderMonitor(let orderId):
            return "/orders/monitor/" + orderId
        case .getOrdersList(let email, _):
            return "/orders/list/" + email + "/"
        case .postBookOrder(_):
            return "/orders/book/"
        case .postCheckout(_, _):
            return "/payments/bt-checkout/" + (NSLocale.current.regionCode?.lowercased() ?? "en") + "/"
        case .p24Status():
            return "/payments/confirm-p24/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postBookOrder(_), .postCheckout(_, _):
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getOffers(_, let offerParameters, _):
            if let offerParameters = offerParameters {
                do {
                    return try wrap(offerParameters)
                } catch _ {
                    return nil
                }
            }
            return nil
        case .postBookOrder(let order):
            do {
                return try wrap(order)
            } catch _ {
                return nil
            }
        case .getOrdersList(_, let sessions):
            return ["sessions": sessions]
        case .postCheckout(let nonce, let sessionId):
            return ["nonce": nonce, "session_id": sessionId]
        default:
            return nil
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getOffers(_, _, _):
            if let path = Bundle.main.path(forResource: "SampleOffers", ofType: "json"),
                let data = Data(base64Encoded: path) {
                return data
            }
        default:
            break
        }
        return "Sample data".utf8Encoded
    }
    
    var task: Task {
        return .request
    }
    
    // MARK: - 
    
    fileprivate func locationPath() -> String {
        if let coordinates = LocationProvider.shared.coordinates() {
            return "\(coordinates.latitude)/\(coordinates.longitude)"
        }
        return "no-location"
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
