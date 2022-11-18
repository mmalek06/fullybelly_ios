import Foundation
import UIKit

protocol StringConfigurable {
    func configure(string: String)
}

class StringConfigurableCell: UITableViewCell, StringConfigurable {
    func configure(string: String) {}
}
