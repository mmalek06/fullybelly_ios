import Foundation
import SwiftyUserDefaults

class Platnosci24Service: NSObject, PaymentService {
    weak var viewController: UIViewController?
    let p24Config = P24Config()
    var p24: P24?
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

    // MARK: - 
    
    func startPayment(offer: Offer, bookOrder: BookOrder, viewController: UIViewController, completion: @escaping ((PaymentResult) -> Void)) {
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
    
    // MARK: - 
    
    func processPayment() {
        if let order = order,
            let configuration = configuration,
            let price = offer.discountPrice,
            let sessionId = order.sessionId,
            let email = Defaults[.email],
            let p24MerchantId = configuration.p24MerchantId,
            let p24CRC = configuration.p24CRC {
            
            let p24Config = P24Config()
            p24Config.merchantId = Int32(p24MerchantId)
            p24Config.crc = p24CRC
            p24Config.storeLoginData = true
            p24Config.dontAskForSaveCredentials = false
            p24Config.useMobileBankStyles = true
            p24Config.timeLimit = 2
            
            p24 = P24(config: p24Config, delegate: self)
            
            let p24Payment = P24Payment()
            p24Payment.amount = Int32(bookOrder.amount * Int(price * 100.00))
            p24Payment.sessionId = sessionId
            p24Payment.currency = "PLN"
            p24Payment.clientCountry = "pl"
            p24Payment.clientEmail = email
            p24Payment.transferLabel = "transferTitle".localized()
            
            if let paymentMethod = Defaults[.paymentMethod],
                paymentMethod == .credit {
                p24Payment.method = "152"
            }
            
            if let paymentMethod = bookOrder.paymentMethod,
                paymentMethod == .credit {
                p24Payment.method = "152"
            }
            
            let p24Status = FullyBellyService.p24Status()
            p24Payment.p24UrlStatus = p24Status.baseURL.absoluteString + p24Status.path
            
            p24?.start(p24Payment, in: self.viewController)
            
        } else {
            if let completion = self.completion {
                completion(PaymentResult.otherFailure)
                self.completion = nil
            }
        }
    }
}

extension Platnosci24Service: P24Delegate {
    func p24(_ p24: P24!, didCancel p24Payment: P24Payment!) {
        if let completion = self.completion {
            completion(PaymentResult.paymentFailure)
            self.completion = nil
        }
    }
    
    func p24(_ p24: P24!, didFail p24Payment: P24Payment!, withError error: Error!) {
        if let completion = self.completion {
            completion(PaymentResult.paymentFailure)
            self.completion = nil
        }
    }
    
    func p24(_ p24: P24!, didFinish p24Payment: P24Payment!, with p24PaymentResult: P24PaymentResult!) {
        if p24PaymentResult.isOk() {
            if let sessionId = order?.sessionId {
                Defaults[.monitoredSessionId] = sessionId
            }
            
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
    }
}
