import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    struct FB {
        static let main = UIColor(hex: 0x4b3c4e) //75, 60, 78
        static let topBar = UIColor(hex: 0x48394b) //72, 57, 75
        static let border = UIColor(hex: 0x948398) //148, 131, 152
        static let backgroundLabel = UIColor(hex: 0x948397)
        static let approveBackgroundLabel = UIColor(hex: 0x00c8a5)
        static let textLabel = UIColor(hex: 0x262626) //38, 38, 38
        static let selected = UIColor(hex: 0x00C9A5)
        static let searchButtonGradientLeft = UIColor(hex: 0xFC9637)
        static let searchButtonGradientRight = UIColor(hex: 0xF07A45)
        static let searchButtonSelectedLabel = UIColor(hex: 0x3F3341)
        static let error = UIColor(hex: 0xD70000)
    }
}
