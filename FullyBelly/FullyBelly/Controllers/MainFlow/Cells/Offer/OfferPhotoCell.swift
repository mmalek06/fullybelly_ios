import Foundation
import UIKit

class OfferPhotoCell: UITableViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoAspectConstraint: NSLayoutConstraint!
    @IBOutlet var restaurantFlagLabel: UILabel! {didSet{restaurantFlagLabel.localized()}}
    
    var photo: UIImage! {
        didSet {
            photoAspectConstraint.setMultiplier(multiplier: photo.size.width / photo.size.height)
            photoImageView.image = photo
        }
    }
}
