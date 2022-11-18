import Foundation
import Wrap

class OffersParameters: NSObject, WrapCustomizable, NSCoding {
    var favorites: Bool?
    var favoriteRestaurants: [String]?
    var availableOffers: Bool?
    var cheapest: Bool?
    var closest: Bool?
    var pickup: Bool?
    var distance: Int?
    
    override init() {
        
    }
    
    convenience init(favorites: Bool?, favoriteRestaurants: [String]?, availableOffers: Bool?, cheapest: Bool?, closest: Bool?, pickup: Bool?, distance: Int?) {
        self.init()
        
        self.favorites = favorites
        self.favoriteRestaurants = favoriteRestaurants
        self.availableOffers = availableOffers
        self.cheapest = cheapest
        self.closest = closest
        self.pickup = pickup
        self.distance = distance
    }
    
    func keyForWrapping(propertyNamed propertyName: String) -> String? {
        switch propertyName {
        case "favoriteRestaurants":
            return "fav-restaurants"
        case "availableOffers":
            return "only-available"
        default:
            break
        }
        
        return propertyName
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()

        self.favorites = aDecoder.decodeObject(forKey: "favorites") as? Bool
        self.favoriteRestaurants = aDecoder.decodeObject(forKey: "favoriteRestaurants") as? [String]
        self.availableOffers = aDecoder.decodeObject(forKey: "availableOffers") as? Bool
        self.cheapest = aDecoder.decodeObject(forKey: "cheapest") as? Bool
        self.closest = aDecoder.decodeObject(forKey: "closest") as? Bool
        self.pickup = aDecoder.decodeObject(forKey: "pickup") as? Bool
        self.distance = aDecoder.decodeObject(forKey: "distance") as? Int
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.favorites, forKey: "favorites")
        aCoder.encode(self.favoriteRestaurants, forKey: "favoriteRestaurants")
        aCoder.encode(self.availableOffers, forKey: "availableOffers")
        aCoder.encode(self.cheapest, forKey: "cheapest")
        aCoder.encode(self.closest, forKey: "closest")
        aCoder.encode(self.pickup, forKey: "pickup")
        aCoder.encode(self.distance, forKey: "distance")
    }
}
