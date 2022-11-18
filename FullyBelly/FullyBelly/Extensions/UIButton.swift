import Foundation
import UIKit

extension UIButton {
    func localized(uppercased: Bool = false) {
        var title = self.title(for: .normal)?.localized()
        if uppercased {
            title = title?.uppercased()
        }
        self.setTitle(title, for: .normal)
    }
}
