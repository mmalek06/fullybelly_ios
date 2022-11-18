import Foundation
import UIKit

extension UISegmentedControl {
    func localized() {
        for i in 0...(self.numberOfSegments-1) {
            setTitle(self.titleForSegment(at: i)?.localized(), forSegmentAt: i)
        }
    }
}
