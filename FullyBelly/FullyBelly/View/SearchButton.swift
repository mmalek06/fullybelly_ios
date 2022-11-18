import Foundation
import UIKit

class SearchButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        gradientLayer.colors = [UIColor.FB.searchButtonGradientLeft.cgColor, UIColor.FB.searchButtonGradientRight.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}
