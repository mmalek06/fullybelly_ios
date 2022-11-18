import Foundation
import UIKit
import SwiftyUserDefaults

enum CellIdentifier: String {
    case name = "OfferNameCell"
    case photo = "OfferPhotoCell"
    case buy = "OfferBuyCell"
    case detailHeader = "OfferDetailHeaderCell"
    case detailText = "OfferDetailTextCell"
    case loading = "OfferLoadingCell"
}

class OfferViewControler: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbarView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var favoriteButton: FavoriteButton!
    
    var cells: [(identifier: CellIdentifier, data: String?)]!
    var photo: UIImage?
    var isFullOffer: Bool = false
    var paymentProvider: PaymentProvider?

    var bookOrder: BookOrder? {
        didSet {
            if let bookOrder = bookOrder {
                if bookOrder.email == "" {
                    performSegue(withIdentifier: "showEmailPopup", sender: self)
                } else if Defaults[.paymentMethod] == nil && bookOrder.paymentMethod == nil, let regionCode = NSLocale.current.regionCode, regionCode.lowercased() == "pl" {
                    performSegue(withIdentifier: "showMethodPopup", sender: self)
                } else {
                    performPayment()
                }
            }
        }
    }
    
    var offer: Offer? {
        didSet {
            if let background = offer?.background {
                _ = UIImageView().kf.setImage(with: URL(string: background)!, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    self.photo = image
                    self.setupCells()
                })
            }
        }
    }

    override func viewDidLoad() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        toolbarView.bindToKeyboard()
        
        // dismiss keyboard on tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "searchCommand".localized(), attributes: [NSForegroundColorAttributeName: UIColor.FB.border])
        if let offer = offer {
            favoriteButton.isFavorited = FavoritesProviders.isFavorite(restaurant: offer.restaurant)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCells()
        refreshData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let locationViewController = segue.destination as? LocationViewController {
            locationViewController.offer = offer
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if let offerOrderPopupVC = segue.destination as? OfferOrderPopupVC,
            let offer = offer {
            offerOrderPopupVC.offer = offer
            offerOrderPopupVC.completion = { bookOrder in
                self.bookOrder = bookOrder
            }
        }
        
        if let emailPopupVC = segue.destination as? EmailPopupVC,
            let bookOrder = bookOrder {
            emailPopupVC.bookOrder = bookOrder
            emailPopupVC.completion = { bookOrder in
                self.bookOrder = bookOrder
            }
        }
        
        if let paymentPopupVC = segue.destination as? PaymentPopupVC,
            let bookOrder = bookOrder {
            paymentPopupVC.bookOrder = bookOrder
            paymentPopupVC.completion = { bookOrder in
                self.bookOrder = bookOrder
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupCells() {
        cells = [(.name, nil)]
        if photo != nil { cells.append((.photo, nil)) }
        
        if let offer = offer, isFullOffer == true {
            if offer.meal != 0 {
                cells.append((.buy, nil))
            }
            
            if let offerDescription = offer.mealDescription, !offerDescription.isEmpty {
                cells.append((.detailHeader, "offerDescription".localized()))
                cells.append((.detailText, offerDescription))
            }
            
            if let city = offer.city,
                let street = offer.street {
                cells.append((.detailHeader, "address".localized()))
                
                var address = "\(city), \(street) "
                address.append([offer.streetNumber, offer.apartmentNumber].flatMap({$0}).joined(separator: "/"))
                cells.append((.detailText, address))
            }
            
            if let restaurantDescription = offer.description, !restaurantDescription.isEmpty {
                cells.append((.detailHeader, "description".localized()))
                cells.append((.detailText, restaurantDescription))
            }
        } else {
            cells.append((.loading, nil))
        }        
        
        tableView.reloadData()
    }
    
    func refreshData() {
        if let offer = offer {
            OffersDownloader.get(restaurantId: offer.restaurant, offerId: offer.meal, offer: { (offer) in
                self.offer = offer
                self.isFullOffer = true
                self.setupCells()
            }) {
                _ = self.navigationController?.popViewController(animated: true)
                
                let alert = UIAlertController(title: "noRestaurantDetailsInfo".localized(), message: "tryDifferentCriteria".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "hideShowButtonHideText".localized(), style: .cancel, handler: nil))
                self.navigationController?.topViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func performPayment() {
        paymentProvider = PaymentProvider()
        
        paymentProvider?.startPayment(offer: self.offer!, bookOrder: self.bookOrder!, viewController: self, completion: { (result) in
            switch result {
            case .success:
                self.showAlert(title: "transactionSuccess".localized(), message: "paymentOk".localized(), dismissGoesRootVC: true)
                
            case .paymentFailure:
                self.showAlert(title: "transactionAbandoned".localized(), message: "paymentCancelled".localized())
                
            case .otherFailure:
                self.showAlert(title: "orderBookingFailed".localized(), message: "tryAgainLater".localized())
            }
        })
    }
    
    func showAlert(title: String, message: String, dismissGoesRootVC: Bool = false) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler:  { (action) in
            if dismissGoesRootVC {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }))
        navigationController?.topViewController?.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        favoriteButton.isFavorited = !favoriteButton.isFavorited
        if let offer = offer {
            favoriteButton.isFavorited
                ? FavoritesProviders.addFavorite(restaurant: offer.restaurant)
                : FavoritesProviders.removeFavorite(restaurant: offer.restaurant)
        }
    }
}

extension OfferViewControler: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let offer = offer {
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].identifier.rawValue, for: indexPath)
            
            if let offerConfigurableCell = cell as? OfferConfigurableCell {
                offerConfigurableCell.configure(offer: offer)
            }
            
            if let stringConfigurableCell = cell as? StringConfigurableCell,
                let data = cells[indexPath.row].data {
                stringConfigurableCell.configure(string: data)
            }
            
            if let photoCell = cell as? OfferPhotoCell {
                photoCell.photo = photo
                if let mealCanEatOnSite = offer.mealCanEatOnSite {
                    photoCell.restaurantFlagLabel.isHidden = !mealCanEatOnSite
                } else {
                    photoCell.restaurantFlagLabel.isHidden = true
                }
            }
            
            return cell
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
    }
}

extension OfferViewControler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension OfferViewControler: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = navigationController?.popViewController(animated: true)
        if let offersViewController = navigationController?.topViewController as? OffersViewController,
            let searchButton = offersViewController.header?.searchButton {
            offersViewController.header?.searchTextField.text = textField.text
            offersViewController.header?.searchAction(searchButton)
        }
        
        return true
    }
}
