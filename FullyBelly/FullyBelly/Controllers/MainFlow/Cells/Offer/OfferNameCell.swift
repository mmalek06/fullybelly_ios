import Foundation
import UIKit

class OfferNameCell: OfferConfigurableCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    
    override func configure(offer: Offer) {
        nameLabel.text = offer.name
        cityLabel.text = offer.city
        
        logoImageView.kf.setImage(with: URL(string: offer.logo))
        
        if let distance = offer.distance {
            distanceLabel.text = "\(distance)km"
        } else {
            distanceLabel.text = nil
        }
    }
}
