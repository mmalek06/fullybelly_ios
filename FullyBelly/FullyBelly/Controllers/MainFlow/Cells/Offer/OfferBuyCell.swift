import Foundation
import UIKit

class OfferBuyCell: OfferConfigurableCell {
    
    @IBOutlet var oldPriceLabel: StrikethroughLabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var availableLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    @IBOutlet var betweenConstraint: NSLayoutConstraint!
    @IBOutlet var leftConstraint: NSLayoutConstraint!
    @IBOutlet var buyButton: SearchButton! {didSet{buyButton.localized(uppercased: true)}}
    @IBOutlet var hoursTextLabel: UILabel! {didSet{hoursTextLabel.localized()}}
    @IBOutlet var availableTextLabel: UILabel! {didSet{availableTextLabel.localized()}}
    
    override func configure(offer: Offer) {
        if let normalPrice = offer.normalPrice,
            let discountPrice = offer.discountPrice {
            if normalPrice > 0 {
                oldPriceLabel.text = String(format: "%.2f", normalPrice) + offer.currency
                priceLabel.text = String(format: "%.2f", discountPrice) + offer.currency
                betweenConstraint.isActive = true
                leftConstraint.isActive = false
            } else {
                oldPriceLabel.text = nil
                priceLabel.text = String(format: "%.2f", discountPrice) + offer.currency
                betweenConstraint.isActive = false
                leftConstraint.isActive = true
            }
        }
        
        if let pickupFrom = offer.pickupFrom,
            let pickupTo = offer.pickupTo {
            hoursLabel.text = pickupFrom + " - " + pickupTo
        }
        
        availableLabel.text = String(offer.availableDishes)
    }
}
