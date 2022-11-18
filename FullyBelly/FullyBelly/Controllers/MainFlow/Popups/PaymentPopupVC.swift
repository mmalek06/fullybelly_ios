import Foundation
import UIKit
import SwiftyUserDefaults

class PaymentPopupVC: UIViewController {
    @IBOutlet var paymentMethodTextLabel: UILabel! {didSet{paymentMethodTextLabel.localized()}}
    @IBOutlet var paymentMethodSegmentedControl: UISegmentedControl! {didSet{paymentMethodSegmentedControl.localized()}}
    @IBOutlet var nextButton: SearchButton! {didSet{nextButton.localized(uppercased: true)}}
    @IBOutlet var rememberPaymentSwitch: UISwitch!
    @IBOutlet var rememberPaymentTextSwitch: UILabel! {didSet{rememberPaymentTextSwitch.localized()}}

    var bookOrder: BookOrder!
    var completion: ((_ bookOrder: BookOrder)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Defaults[.paymentMethod] != nil {
            nextButton.setTitle("buttonBuyText".localized(uppercase: true), for: .normal)
        }
    }
    
    // MARK: -
    
    @IBAction func paymentMethodValueChange(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if rememberPaymentSwitch.isOn {
            Defaults[.paymentMethod] = PaymentMethod(rawValue: paymentMethodSegmentedControl.selectedSegmentIndex)
        }
        
        dismiss(animated: true) {
            if let completion = self.completion {
                if !self.rememberPaymentSwitch.isOn {
                    self.bookOrder?.paymentMethod = PaymentMethod(rawValue: self.paymentMethodSegmentedControl.selectedSegmentIndex)
                }
                
                completion(self.bookOrder)
            }
        }
    }
}

extension PaymentPopupVC: MIBlurPopupDelegate {
    var popupView: UIView { return self.view }
    var blurEffectStyle: UIBlurEffectStyle { return .extraLight }
    var initialScaleAmmount: CGFloat { return 0.5 }
    var animationDuration: TimeInterval { return 0.5 }
}
