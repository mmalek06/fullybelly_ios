import Foundation
import UIKit

class OfferNoDataCell: UITableViewCell {
    @IBOutlet var headlineLabel: UILabel! {didSet{headlineLabel.localized()}}
    @IBOutlet var subHeadlineLabel: UILabel! {didSet{subHeadlineLabel.localized()}}
    
    var emptyResults: Bool = false {
        didSet {
            headlineLabel.text = "noRestaurantsInfo".localized()
            subHeadlineLabel.text = "tryDifferentCriteria".localized()
            
            if emptyResults && LocationProvider.shared.coordinates() == nil {
                headlineLabel.text = "locationDown".localized()
                subHeadlineLabel.text = "locationDownExplanation".localized()
            }
        }
    }
}
