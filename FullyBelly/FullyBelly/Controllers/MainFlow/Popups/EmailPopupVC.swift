import Foundation
import UIKit
import SwiftyUserDefaults

class EmailPopupVC: UIViewController {
    @IBOutlet var validationConstraint: NSLayoutConstraint!
    @IBOutlet var buyButton: SearchButton! {didSet{buyButton.localized(uppercased: true)}}
    @IBOutlet var emailTextLabel: UILabel! {didSet{emailTextLabel.localized()}}
    @IBOutlet var invalidEmailLabel: UILabel! {didSet{invalidEmailLabel.localized()}}
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var underlineView: UIView!
    
    var bookOrder: BookOrder!
    var completion: ((_ bookOrder: BookOrder)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Defaults[.paymentMethod] != nil {
            buyButton.setTitle("buttonBuyText".localized(uppercase: true), for: .normal)
        }
    }
    
    @IBAction func buyAction(_ sender: Any) {
        let validation = ValidationProvider.emailValidation(textField: emailTextField, underlineView: underlineView, invalidEmailLabel: invalidEmailLabel, view: view)
        if validation {
            complete()
        } else {
            validationConstraint.constant = 50
        }
    }
    
    func complete() {
        dismiss(animated: true, completion: {
            if let email = Defaults[.email], let completion = self.completion {
                self.bookOrder.email = email
                completion(self.bookOrder)
            }
        })
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension EmailPopupVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let validation = ValidationProvider.emailValidation(textField: textField, underlineView: underlineView, invalidEmailLabel: invalidEmailLabel, view: view)
        
        if validation {
            validationConstraint.constant = 30
            complete()
        } else {
            validationConstraint.constant = 50
        }
        
        return validation
    }
}

extension EmailPopupVC: MIBlurPopupDelegate {
    var popupView: UIView { return self.view }
    var blurEffectStyle: UIBlurEffectStyle { return .extraLight }
    var initialScaleAmmount: CGFloat { return 0.5 }
    var animationDuration: TimeInterval { return 0.5 }
}
