import Foundation
import UIKit

class OfferDetailsCell: OfferConfigurableCell {
    @IBOutlet var stackView: UIStackView!
    
    override func prepareForReuse() {
        stackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
            stackView.removeArrangedSubview(view)
        }
    }
    
    override func configure(offer: Offer) {
        if let offerDescription = offer.mealDescription, !offerDescription.isEmpty {
            stackView.addArrangedSubview(label(header: "offerDescription".localized()))
            stackView.addArrangedSubview(label(detail: offerDescription))
        }
        
        if let city = offer.city,
            let street = offer.street {
            stackView.addArrangedSubview(label(header: "address".localized()))
            
            var address = "\(city), \(street) "
            address.append([offer.streetNumber, offer.apartmentNumber].flatMap({$0}).joined(separator: "/"))
            stackView.addArrangedSubview(label(detail: address))
        }
        
        if let restaurantDescription = offer.description, !restaurantDescription.isEmpty {
            stackView.addArrangedSubview(label(header: "description".localized()))
            stackView.addArrangedSubview(label(detail: restaurantDescription))
        }
        
    }
    
    internal func label(header text:String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont(name: "Raleway-Bold", size: 15)
        label.textColor = UIColor.FB.textLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        
        label.text = text
        
        return label
    }
    
    internal func label(detail text: String) -> UILabel {
        let label = self.label(header: text)
        label.font = UIFont(name: "Raleway-Medium", size: 15)
        
        return label
    }
}
