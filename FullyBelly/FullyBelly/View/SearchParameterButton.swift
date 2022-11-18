import Foundation
import UIKit

class SearchParameterButton: UIButton {
    @IBOutlet weak var icon: UIImageView?
    override var alpha: CGFloat {
        didSet {
            icon?.alpha = alpha
        }
    }
    
    var selectedState: Bool = false {
        didSet {
            let titleColor = selectedState ? UIColor.FB.searchButtonSelectedLabel : UIColor.FB.border
            let backgroundColor = selectedState ? UIColor.FB.selected : UIColor.clear
            let borderColor = selectedState ? UIColor.FB.selected : UIColor.FB.border
            
            setTitleColor(titleColor, for: .normal)
            layer.borderColor = borderColor.cgColor
            self.backgroundColor = backgroundColor
            icon?.tintColor = titleColor
        }
    }
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = selectedState ? UIColor.FB.selected.cgColor : UIColor.FB.border.cgColor
        contentEdgeInsets = UIEdgeInsets(top: 13, left: 7, bottom: 13, right: 7)
    }
}
