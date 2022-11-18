import Foundation
import UIKit

class OfferDetailHeaderCell: StringConfigurableCell {
    
    @IBOutlet var headerLabel: UILabel!
    
    override func configure(string: String) {
        headerLabel.text = string
    }
}
