import Foundation
import CoreLocation

class LocationProvider {
    static let shared = LocationProvider()
    var supplier: LocationSupplier?
    
    func coordinates() -> CLLocationCoordinate2D? {
        guard let supplier = supplier else {
            return nil
        }
        
        return supplier.locationCoordinate
    }
}

// MARK: -

protocol LocationSupplier {
    var locationCoordinate: CLLocationCoordinate2D? { get }
}

struct MockLocationManager {
    init(lat: Double, lon: Double) {
        coordinates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    var coordinates: CLLocationCoordinate2D?
}

extension MockLocationManager: LocationSupplier {
    var locationCoordinate: CLLocationCoordinate2D? {
        return coordinates
    }
}

extension CLLocationManager: LocationSupplier {
    var locationCoordinate: CLLocationCoordinate2D? {
        return self.location?.coordinate
    }
}
