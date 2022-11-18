import Foundation
import Alamofire

public struct BTEncoding: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters as? [String: String] else { return urlRequest }
        
        var printedParameters = ""
        parameters.forEach { (key, value) in
            printedParameters = "\(key)=\(value)"
        }
        
        urlRequest.httpBody = printedParameters.data(using: .utf8, allowLossyConversion: false)
        
        
        return urlRequest
    }
}
