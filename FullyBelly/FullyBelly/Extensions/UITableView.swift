import Foundation
import UIKit

extension UITableView {
    func sizeHeaderToFit() {
        guard let headerView = self.tableHeaderView else {
            return
        }
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let layout = NSLayoutConstraint(
            item: headerView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute:
            .notAnAttribute,
            multiplier: 1,
            constant: self.frame.width)
        
        headerView.addConstraint(layout)
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        headerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height)
        
        headerView.removeConstraint(layout)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
        self.tableHeaderView = headerView
    }
}
