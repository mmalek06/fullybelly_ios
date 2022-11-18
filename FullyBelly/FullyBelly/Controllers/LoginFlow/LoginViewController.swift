import Foundation
import UIKit
import SwiftyUserDefaults

class LoginViewController: UIViewController {
    @IBOutlet var guestLoginButton: RoundedButton! { didSet { guestLoginButton.localized() } }
    @IBOutlet var tacButton: UIButton! { didSet { tacButton.localized() } }
    
    var tacText: NSAttributedString?
    var tacVersion: Int?
    
    override func viewDidLoad() {
        TACDownloader.get(tac: { (tac) in
            if Defaults[.TACAcceptedVersion] != tac.versionId {
                do {
                    let tacStyled = "<style>body{font-family: 'Raleway'; font-size:11px; color:#948398}</style>" + tac.text
                    let data = tacStyled.data(using: String.Encoding.unicode)
                    if let data = data {
                        self.tacText = try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                        self.tacVersion = tac.versionId
                    }
                } catch let error {
                    print(error)
                    Defaults[.TACAcceptedVersion] = tac.versionId
                    Defaults[.TACUserAccepted] = true
                }
            }
        }) {
            Defaults[.TACUserAccepted] = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func guestLoginAction(_ sender: Any) {
        if let userAccepted = Defaults[.TACUserAccepted],
            userAccepted == true {
            performSegue(withIdentifier: "showMainFlow", sender: self)
        } else if tacText != nil {
            performSegue(withIdentifier: "showManualTAC", sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showTAC", tacText == nil {
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tacVC = segue.destination as? TACViewController {
            tacVC.tacText = self.tacText
            tacVC.tacVersion = self.tacVersion
        }
        
        if segue.identifier == "showManualTAC",
            let tacVC = segue.destination as? TACViewController {
            tacVC.showMainFlowOnUserApproval = true
        }
    }
}
