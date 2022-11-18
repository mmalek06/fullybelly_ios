import Foundation
import UIKit
import SwiftyUserDefaults

enum HeaderHeight {
    case expanded
    case shrunk
}

protocol OffersSearchHeaderDelegate: class {
    func searchHeaderDidSearch(query: String?, params: OffersParameters?)
    func searchHeaderHeightChange(size: HeaderHeight)
}

class OffersSearchHeader: UIView {
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var availableButton: SearchParameterButton! {didSet{availableButton.localized()}}
    @IBOutlet var favoriteButton: SearchParameterButton! {didSet{favoriteButton.localized()}}
    @IBOutlet var timeReceiveButton: SearchParameterButton! {didSet{timeReceiveButton.localized()}}
    @IBOutlet var closestButton: SearchParameterButton! {didSet{closestButton.localized()}}
    @IBOutlet var cheapestButton: SearchParameterButton! {didSet{cheapestButton.localized()}}
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var distanceSliderConstraint: NSLayoutConstraint!
    @IBOutlet var distanceLabel: UILabel! {didSet{distanceLabel.localized()}}
    @IBOutlet var collapseButton: UIButton! {didSet{collapseButton.localized(uppercased: true)}}
    @IBOutlet var searchButton: SearchButton! {didSet{searchButton.localized(uppercased: true)}}
    
    weak var delegate: OffersSearchHeaderDelegate?
    var size: HeaderHeight = .shrunk
    
    override func awakeFromNib() {
        searchTextField.attributedPlaceholder = NSAttributedString(string: "searchTerm".localized(), attributes: [NSForegroundColorAttributeName: UIColor.FB.border])
        
        let thumbRect = distanceSlider.thumbRect(forBounds: distanceSlider.bounds, trackRect: distanceSlider.trackRect(forBounds: distanceSlider.bounds), value: distanceSlider.value)
        distanceSliderConstraint.constant = thumbRect.origin.x - 70
        timeReceiveButton.alpha = 0
        closestButton.alpha = 0
        cheapestButton.alpha = 0
        distanceSlider.alpha = 0
        distanceLabel.alpha = 0
        
        if let lastOffersParameters = Defaults[.lastOffersParameters] {
            availableButton.selectedState = lastOffersParameters.availableOffers ?? false
            favoriteButton.selectedState = lastOffersParameters.favorites ?? false
            timeReceiveButton.selectedState = lastOffersParameters.pickup ?? false
            closestButton.selectedState = lastOffersParameters.closest ?? false
            cheapestButton.selectedState = lastOffersParameters.cheapest ?? false
        }
    }
    
    fileprivate func switchButtonsVisibility(visible: Bool) {
        UIView.animate(withDuration: visible ? 0.45 : 0.1) {
            if visible {
                self.timeReceiveButton.alpha = 1
                self.closestButton.alpha = 1
                self.cheapestButton.alpha = 1
                self.distanceSlider.alpha = 1
                self.distanceLabel.alpha = 1
            } else {
                self.timeReceiveButton.alpha = 0
                self.closestButton.alpha = 0
                self.cheapestButton.alpha = 0
                self.distanceSlider.alpha = 0
                self.distanceLabel.alpha = 0
            }
        }
    }
    
// MARK: -
    
    @IBAction func searchAction(_ sender: SearchButton) {
        if let delegate = delegate {
            var offersParameters: OffersParameters?
                
            if favoriteButton.selectedState || availableButton.selectedState || timeReceiveButton.selectedState || cheapestButton.selectedState || closestButton.selectedState || distanceSlider.value < distanceSlider.maximumValue {
                offersParameters = OffersParameters(
                    favorites: favoriteButton.selectedState ? true : nil,
                    favoriteRestaurants: favoriteButton.selectedState ? FavoritesProviders.favoritesStrings() : nil,
                    availableOffers: availableButton.selectedState ? true : nil,
                    cheapest: cheapestButton.selectedState ? true : nil,
                    closest: closestButton.selectedState ? true : nil,
                    pickup: timeReceiveButton.selectedState ? true : nil,
                    distance: distanceSlider.value < distanceSlider.maximumValue ? Int(distanceSlider.value) : nil)
            }
            
            Defaults[.lastOffersParameters] = offersParameters
            delegate.searchHeaderDidSearch(query: searchTextField.text, params: offersParameters)
        }
    }
    
    func fireSearch() {
        searchAction(searchButton)
    }
    
    @IBAction func heightAction(_ sender: UIButton) {
        if size == .shrunk {
            size = .expanded
            switchButtonsVisibility(visible: true)
            sender.setTitle("simpleSearchText".localized().uppercased(), for: .normal)
        } else {
            size = .shrunk
            switchButtonsVisibility(visible: false)
            sender.setTitle("advancedSearchText".localized().uppercased(), for: .normal)
        }
        
        delegate?.searchHeaderHeightChange(size: size)
    }
    
    @IBAction func favoriteAction(_ sender: SearchParameterButton) {
        sender.selectedState = !sender.selectedState
    }
    
    @IBAction func availableAction(_ sender: SearchParameterButton) {
        sender.selectedState = !sender.selectedState
    }
    
    @IBAction func timeReceiveAction(_ sender: SearchParameterButton) {
        sender.selectedState = !sender.selectedState
        if sender.selectedState {
            closestButton.selectedState = false
            cheapestButton.selectedState = false
        }
    }
    
    @IBAction func closestAction(_ sender: SearchParameterButton) {
        sender.selectedState = !sender.selectedState
        if sender.selectedState {
            timeReceiveButton.selectedState = false
            cheapestButton.selectedState = false
        }
    }
    
    @IBAction func cheapestAction(_ sender: SearchParameterButton) {
        sender.selectedState = !sender.selectedState
        if sender.selectedState {
            timeReceiveButton.selectedState = false
            closestButton.selectedState = false
        }
    }
    
    @IBAction func distanceAction(_ sender: UISlider) {
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: sender.trackRect(forBounds: sender.bounds), value: sender.value)
        
        if sender.value >= sender.maximumValue {
            distanceLabel.text = "anyDistance".localized()
            distanceLabel.sizeToFit()
            distanceSliderConstraint.constant = thumbRect.origin.x - (distanceLabel.frame.width/2)
        } else {
            distanceLabel.text = "\(Int(sender.value)) km"
            distanceSliderConstraint.constant = thumbRect.origin.x - 5
        }
    }
}

extension OffersSearchHeader: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction(searchButton)
        return true
    }
}
