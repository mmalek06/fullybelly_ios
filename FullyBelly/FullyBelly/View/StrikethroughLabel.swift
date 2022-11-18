import Foundation
import UIKit

class StrikethroughLabel: UILabel {
    override var text: String? {
        didSet {
            let attributedString = NSAttributedString(string: text ?? "", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
            self.attributedText = attributedString
        }
    }
}
