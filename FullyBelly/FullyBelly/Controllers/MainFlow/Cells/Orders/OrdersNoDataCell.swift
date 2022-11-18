import Foundation
import UIKit

class OrdersNoDataCell: UITableViewCell {
    @IBOutlet var noDataLabel: UILabel! {didSet{noDataLabel.localized()}}
}
