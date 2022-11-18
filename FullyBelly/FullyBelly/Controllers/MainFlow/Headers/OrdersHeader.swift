import Foundation
import UIKit

class OrdersHeader: UIView {
    @IBOutlet var headerLabel: UILabel! {didSet{headerLabel.localized()}}
}
