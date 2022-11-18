import Foundation
import UIKit
import SwiftyUserDefaults

class TACViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    @IBOutlet var declineButton: RoundedButton! { didSet { declineButton.localized() } }
    @IBOutlet var acceptButton: RoundedButton! { didSet { acceptButton.localized() } }
    @IBOutlet var scrollDownButton: RoundedButton! { didSet { scrollDownButton.localized() } }
    
    var showMainFlowOnUserApproval: Bool?
    var tacText: NSAttributedString!
    var tacVersion: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.textContainer.lineFragmentPadding = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textView.attributedText = tacText
    }
    
    @IBAction func declineAction(_ sender: Any) {
        Defaults[.TACUserAccepted] = nil
        Defaults[.TACAcceptedVersion] = nil
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func approveAction(_ sender: Any) {
        Defaults[.TACUserAccepted] = true
        Defaults[.TACAcceptedVersion] = tacVersion
        
        if let showMainFlowOnUserApproval = showMainFlowOnUserApproval, showMainFlowOnUserApproval {
            performSegue(withIdentifier: "showMainFlow", sender: self)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func gotoBottomAction(_ sender: Any) {
        textView.scrollRangeToVisible(NSRange(location: textView.attributedText.length-1, length: 1))
    }
}
