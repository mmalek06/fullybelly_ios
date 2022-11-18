import Foundation
import Moya

struct Network {
    static let provider = MoyaProvider<FullyBellyService>(endpointClosure: fullyBellyEndpointClosure)
    static let stubProvider = MoyaProvider<FullyBellyService>(endpointClosure: fullyBellyEndpointClosure, stubClosure: MoyaProvider.immediatelyStub)
    
    static func request(
        target: FullyBellyService,
        success successCallback: @escaping (Any) -> Void,
        failure failureCallback: @escaping (Swift.Error) -> Void
        ) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let json = try response.mapJSON()
                    successCallback(json)
                }
                catch let error {
                    failureCallback(error)
                }
            case let .failure(error):
                failureCallback(error)
            }
        }
    }
}

let fullyBellyEndpointClosure = { (target: FullyBellyService) -> Endpoint<FullyBellyService> in
    return closure(target: target)
}

func closure(target: FullyBellyService) -> Endpoint<FullyBellyService> {
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString.replacingOccurrences(of: "%3F", with: "?")
    let httpHeaderFields = ["Accept-Language": NSLocale.current.languageCode?.lowercased() ?? "en",
                            "Accept": "application/json",
                            "Content-Type": "application/json"]
    let parameterEncoding: ParameterEncoding!
    
    switch target {
    case .postBookOrder(_), .postCheckout(_):
        parameterEncoding = JSONEncoding.default
    default:
        parameterEncoding = FBURLEncoding.methodDependent
    }
    
    let endpoint = Endpoint<FullyBellyService>(url: url, sampleResponseClosure: { .networkResponse(200, target.sampleData) }, method: target.method, parameters: target.parameters, parameterEncoding: parameterEncoding, httpHeaderFields: httpHeaderFields)
    
    return endpoint
}
