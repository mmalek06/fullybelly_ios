
import Foundation
import UIKit

class LineSpacingLabel: UILabel {
    override var text: String? {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = self.textAlignment
            let attributedString = NSAttributedString(string: text!, attributes: [NSParagraphStyleAttributeName: paragraphStyle])
            self.attributedText = attributedString
        }
    }
}
