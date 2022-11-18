import Foundation
import UIKit

class OfferDetailTextCell: StringConfigurableCell {
    
    @IBOutlet var stringLabel: UILabel!
    
    override func configure(string: String) {
        stringLabel.text = string
    }
}
