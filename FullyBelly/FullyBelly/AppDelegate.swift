import UIKit
import CoreLocation
import SwiftyUserDefaults
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupWindowAndViewController()
        setupAppearance()
        setupLocationManager()
        
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func setupWindowAndViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if Defaults[.TACUserAccepted] == true {
            let mainFlow = UIStoryboard(name: "MainFlow", bundle: nil).instantiateInitialViewController() as! UITabBarController
            window?.rootViewController = mainFlow
            TACDownloader.get(tac: { (termsAndConditions) in
                if termsAndConditions.versionId != Defaults[.TACAcceptedVersion] {
                    mainFlow.performSegue(withIdentifier: "loginSegue", sender: mainFlow)
                }
            }, fail: {
                
            })
        } else {
            window?.rootViewController = UIStoryboard(name: "LoginFlow", bundle: nil).instantiateInitialViewController()
        }
        
        window?.makeKeyAndVisible()
    }
    
    func setupAppearance() {
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager?.distanceFilter = 500
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
            LocationProvider.shared.supplier = locationManager
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
    }
}
