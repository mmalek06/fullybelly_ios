import Foundation
import UIKit
import Kingfisher

class OfferCell: UITableViewCell {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var offersCountLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    @IBOutlet var discountFromLabel: UILabel!
    @IBOutlet var discountToLabel: UILabel!
    @IBOutlet var offersCountTextLabel: UILabel! {didSet{offersCountTextLabel.localized()}}
    
    func configureCell(offer: Offer) {
        nameLabel.text = offer.name
        if let distance = offer.distance {
            distanceLabel.text = "distance".localized() + " " + String(distance) + "km"
        } else {
            distanceLabel.text = nil
        }
        
        offersCountLabel.text = String(offer.availableDishes)
        logoImageView.kf.setImage(with: URL(string: offer.logo))
        
        if let discountPrice = offer.discountPrice,
            discountPrice > 0,
            let pickupFrom = offer.pickupFrom,
            let pickupTo = offer.pickupTo {
            discountPriceLabel.text = String(format: "%.2f", discountPrice) + offer.currency
            discountFromLabel.text = "from".localized() + " " + pickupFrom
            discountToLabel.text = "until".localized() + " " + pickupTo
        } else {
            discountPriceLabel.text = "-"
            discountFromLabel.text = "from".localized() + " -"
            discountToLabel.text = "until".localized() + " -"
        }
    }
}
