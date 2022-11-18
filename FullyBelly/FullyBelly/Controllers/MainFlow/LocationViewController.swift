import Foundation
import UIKit
import MapKit

class LocationViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    
    var offer: Offer?
    let pin = MKPointAnnotation()
    
    override func viewDidAppear(_ animated: Bool) {
        if let offer = offer, let _ = offer.latitude, let _ = offer.longitude {
            setupAnnotation()
        } else {
            if let offer = offer {
                OffersDownloader.get(restaurantId: offer.restaurant, offerId: nil, offer: { (fetchedOffer) in
                    self.offer = fetchedOffer
                    self.setupAnnotation()
                }, fail: {
                    
                })
            }
        }
    }
    
    func setupAnnotation() {
        if let offer = offer, let latitude = offer.latitude, let longitude = offer.longitude {
            let restaurantlocation = CLLocationCoordinate2DMake(latitude, longitude)
            pin.coordinate = restaurantlocation
            pin.title = offer.name
            mapView.addAnnotation(pin)
            
            mapView.showAnnotations([pin], animated: true)
        }
    }
}
