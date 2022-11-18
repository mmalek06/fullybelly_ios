import Foundation
import UIKit
import SwiftyUserDefaults

struct ValidationProvider {
    @discardableResult
    static func emailValidation(textField: UITextField, underlineView: UIView, invalidEmailLabel: UILabel, view: UIView) -> Bool {
        view.endEditing(true)
        if let emailText = textField.text, ValidationProvider.validate(email: emailText) {
            underlineView.backgroundColor = UIColor.FB.approveBackgroundLabel
            invalidEmailLabel.isHidden = true
            
            Defaults[.email] = textField.text
            return true
        } else {
            underlineView.backgroundColor = UIColor.FB.error
            invalidEmailLabel.isHidden = false
            
            Defaults[.email] = nil
            return false
        }
    }
    
    fileprivate static func validate(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
