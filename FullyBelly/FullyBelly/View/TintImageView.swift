import UIKit

class TintImageView: UIImageView {
    override func awakeFromNib() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
    }
}
