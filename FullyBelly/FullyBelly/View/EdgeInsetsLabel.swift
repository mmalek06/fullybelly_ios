import Foundation
import UIKit

class EdgeInsetsLabel: UILabel {
    let edgeInsets = UIEdgeInsets(top: 7, left: 10, bottom: 7, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        return size
    }
}
