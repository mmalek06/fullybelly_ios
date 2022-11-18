import Foundation
import UIKit

class RoundedButton: UIButton {
    @IBInspectable var margins: Bool = false {
        didSet {
            if margins {
                contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            }
        }
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = 7
        layer.borderWidth = 1
        layer.borderColor = titleColor(for: .normal)?.cgColor
        
        if !margins {
            contentEdgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
        }
    }
}
