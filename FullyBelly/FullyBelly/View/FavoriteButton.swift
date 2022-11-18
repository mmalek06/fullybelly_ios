import Foundation
import UIKit

class FavoriteButton: UIButton {
    var isFavorited: Bool = false {
        didSet {
            tintColor = isFavorited ? UIColor.FB.approveBackgroundLabel : UIColor.FB.border
        }
    }
    
    override func awakeFromNib() {
        setImage(image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        tintColor = isFavorited ? UIColor.FB.approveBackgroundLabel : UIColor.FB.border
    }
}
