import Foundation
import UIKit

protocol OfferConfigurable {
    func configure(offer: Offer)
}

class OfferConfigurableCell: UITableViewCell, OfferConfigurable {
    func configure(offer: Offer) {}
}
