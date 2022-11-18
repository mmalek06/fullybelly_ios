import Foundation
import UIKit

class OfferLoadingCell: UITableViewCell {
    @IBOutlet var loadingLabel: UILabel! {didSet{loadingLabel.localized()}}
}
