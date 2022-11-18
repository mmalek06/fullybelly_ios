import Foundation
import UIKit
import SwiftyUserDefaults

class SettingsViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var underlineView: UIView!
    @IBOutlet var invalidEmailLabel: UILabel! {didSet{invalidEmailLabel.localized()}}
    @IBOutlet var yourEmailLabel: UILabel! {didSet{yourEmailLabel.localized()}}
    @IBOutlet var paymentMethodTextLabel: UILabel! {didSet{paymentMethodTextLabel.localized()}}
    @IBOutlet var paymentMethodSegmentedControl: UISegmentedControl! {didSet{paymentMethodSegmentedControl.localized()}}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationController?.tabBarItem.title = "tabSettings".localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "LogoText"))
        emailTextField.attributedPlaceholder = NSAttributedString(string: "emailAddress".localized(), attributes: [NSForegroundColorAttributeName: UIColor.FB.border])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.text = Defaults[.email]
        underlineView.backgroundColor = UIColor.FB.approveBackgroundLabel
        invalidEmailLabel.isHidden = true
        
        if let paymentMethod = Defaults[.paymentMethod] {
            paymentMethodSegmentedControl.selectedSegmentIndex = paymentMethod.rawValue
        }
        
        var hiddenPaymentMethod = true
        if let regionCode = NSLocale.current.regionCode, regionCode.lowercased() == "pl" {
            hiddenPaymentMethod = false
        }
        
        paymentMethodTextLabel.isHidden = hiddenPaymentMethod
        paymentMethodSegmentedControl.isHidden = hiddenPaymentMethod
    }
    
    @IBAction func paymentMethodValueChange(_ sender: UISegmentedControl) {
        Defaults[.paymentMethod] = PaymentMethod(rawValue: sender.selectedSegmentIndex)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return ValidationProvider.emailValidation(textField: textField, underlineView: underlineView, invalidEmailLabel: invalidEmailLabel, view: view)
    }
}
