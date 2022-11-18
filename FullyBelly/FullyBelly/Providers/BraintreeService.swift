import Foundation
import BraintreeDropIn
import Braintree
import SwiftyUserDefaults

// TEMPORARY FLAG TO DISABLE/ENABLE BRAINTREE PAYMENTS
let braintreeEnabled: Bool = true

class BraintreeService: NSObject, PaymentService {
    weak var viewController: UIViewController?
    var completion: ((PaymentResult) -> Void)?
    var offer: Offer!
    var bookOrder: BookOrder!
    var configuration: Configuration?
    
    var order: Order? {
        didSet {
            if order != nil {
                processPayment()
            }
        }
    }
    
    func startPayment(offer: Offer, bookOrder: BookOrder, viewController: UIViewController, completion: @escaping ((PaymentResult) -> Void)) {
        
        guard braintreeEnabled else {
            completion(.otherFailure)
            return
        }
        
        self.completion = completion
        self.offer = offer
        self.bookOrder = bookOrder
        self.viewController = viewController
        
        ConfigurationDownloader.get(configuration: { (configuration) in
            self.configuration = configuration
            
            OrdersDownloader.post(bookOrder: bookOrder, order: { (order) in
                self.order = order
            }, fail: {
                if let completion = self.completion {
                    completion(PaymentResult.otherFailure)
                    self.completion = nil
                }
            })
            
        }) {
            if let completion = self.completion {
                completion(PaymentResult.otherFailure)
                self.completion = nil
            }
        }
    }
    
    func processPayment() {
        guard let token = configuration?.token else { return }
        
        let request =  BTDropInRequest()
        request.amount = String(bookOrder.amount)
        request.currencyCode = offer.currency

        let dropIn = BTDropInController(authorization: token, request: request)
        { (controller, result, error) in
            if (error != nil) {
                if let completion = self.completion {
                    completion(PaymentResult.otherFailure)
                    self.completion = nil
                }
            } else if (result?.isCancelled == true) {
                if let completion = self.completion {
                    completion(PaymentResult.otherFailure)
                    self.completion = nil
                }
            } else if let result = result {
                if let nonce = result.paymentMethod?.nonce,
                    let sessionId = self.order?.sessionId {
                    CheckoutDownloader.checkout(nonce: nonce, sessionId: sessionId, transaction: { (transaction) in
                        if transaction.transactionSuccessful {
                            Defaults[.monitoredSessionId] = sessionId
                            
                            if let completion = self.completion {
                                completion(PaymentResult.success)
                                self.completion = nil
                            }
                        } else {
                            if let completion = self.completion {
                                completion(PaymentResult.paymentFailure)
                                self.completion = nil
                            }
                        }
                    }, fail: {
                        if let completion = self.completion {
                            completion(PaymentResult.otherFailure)
                            self.completion = nil
                        }
                    })
                } else {
                    if let completion = self.completion {
                        completion(PaymentResult.otherFailure)
                        self.completion = nil
                    }
                }
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
        viewController?.present(dropIn!, animated: true, completion: nil)
    }
}
