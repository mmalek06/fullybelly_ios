import Foundation

enum PaymentServiceType {
    case platnosci24
    case braintree
}

enum PaymentResult {
    case success
    case otherFailure
    case paymentFailure
}

protocol PaymentService {
    func startPayment(offer: Offer, bookOrder: BookOrder, viewController: UIViewController, completion: @escaping  ((_ result: PaymentResult) -> Void))
}

struct PaymentProvider {
    var service: PaymentService
    
    init() {
        if let regionCode = NSLocale.current.regionCode,
            regionCode.lowercased() == "pl" {
            service = Platnosci24Service()
        } else {
            service = BraintreeService()
        }
    }
    
    func startPayment(offer: Offer, bookOrder: BookOrder, viewController: UIViewController, completion: @escaping ((_ result: PaymentResult) -> Void)) {
        service.startPayment(offer: offer, bookOrder: bookOrder, viewController: viewController, completion: completion)
    }
}
