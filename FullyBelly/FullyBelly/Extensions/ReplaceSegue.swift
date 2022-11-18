import Foundation
import UIKit

class ReplaceSegue: UIStoryboardSegue {
    override func perform() {
        UIApplication.shared.keyWindow?.rootViewController = self.destination
    }
}
