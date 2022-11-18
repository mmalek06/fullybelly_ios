import Foundation
import UIKit
import SwiftyUserDefaults

class OfferOrderPopupVC: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet var amountTextLabel: UILabel! {didSet{amountTextLabel.localized()}}
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var timeTextLabel: UILabel! {didSet{timeTextLabel.localized()}}
    @IBOutlet var nextButton: SearchButton! {didSet{nextButton.localized(uppercased: true)}}
    @IBOutlet var timeLabel: UILabel!
    
    var offer: Offer!
    var completion: ((_ bookOrder: BookOrder)->Void)?
    var amount: Int! {
        didSet {
            amountLabel.text = String(amount)
            if let discountPrice = offer.discountPrice {
                let price = discountPrice * Double(amount)
                priceLabel.text = String(format: "%.2f", price) + " \(offer.currency)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Defaults[.email] != nil && Defaults[.paymentMethod] != nil {
            nextButton.setTitle("buttonBuyText".localized(uppercase: true), for: .normal)
        }
        
        if let discountPrice = offer.discountPrice,
            let pickupFrom = offer.pickupFrom,
            let pickupTo = offer.pickupTo {
            priceLabel.text = String(discountPrice) + " " + offer.currency
            timeLabel.text = ["from".localized(), pickupFrom, "until".localized(), pickupTo].joined(separator: " ")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amount = 1
    }
    
    // MARK: -
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func addAmountAction(_ sender: Any) {
        amount = (amount+1).clamped(to: 1...offer.availableDishes)
    }

    @IBAction func removeAmountAction(_ sender: Any) {
        amount = (amount-1).clamped(to: 1...offer.availableDishes)
    }

    @IBAction func nextAction(_ sender: Any) {
        dismiss(animated: true) {
            if let completion = self.completion {
                let bookOrder = BookOrder(restaurant: self.offer.restaurant,
                                          email: Defaults[.email] ?? "",
                                          meal: self.offer.meal,
                                          amount: self.amount,
                                          paymentMethod: nil)
                completion(bookOrder)
            }
        }
    }
}

extension OfferOrderPopupVC: MIBlurPopupDelegate {
    var popupView: UIView { return self.view }
    var blurEffectStyle: UIBlurEffectStyle { return .extraLight }
    var initialScaleAmmount: CGFloat { return 0.5 }
    var animationDuration: TimeInterval { return 0.5 }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
