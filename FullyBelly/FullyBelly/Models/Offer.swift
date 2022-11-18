import Foundation
import Unbox
import Kingfisher

class Offer: Unboxable {
    var availableDishes: Int = 0
    var currency: String = ""
    var restaurant: Int = 0
    var logo: String = ""
    var meal: Int = 0
    var name: String = ""
    
    var pickupFrom: String?
    var pickupTo: String?
    var discountPrice: Double?
    var distance: Double?
    var description: String?
    var background: String?
    var city: String?
    var street: String?
    var streetNumber: String?
    var apartmentNumber: String?
    var comments: String?
    var commentsCount: Int?
    var normalPrice: Double?
    var latitude: Double?
    var longitude: Double?
    var mealDescription: String?
    var mealCanEatOnSite: Bool?
    
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        
        availableDishes = try unboxer.unbox(key: "available_dishes")
        currency = try unboxer.unbox(key: "currency")
        logo = try unboxer.unbox(key: "logo")
        meal = try unboxer.unbox(key: "meal_id")
        name = try unboxer.unbox(key: "name")
        restaurant = try unboxer.unbox(key: "restaurant_id")
        
        discountPrice = unboxer.unbox(key: "discount_price")
        distance = unboxer.unbox(key: "distance")
        pickupFrom = unboxer.unbox(key: "pickup_from")
        pickupTo = unboxer.unbox(key: "pickup_to")
        description = unboxer.unbox(key: "description")
        background = unboxer.unbox(key: "background")
        city = unboxer.unbox(key: "city")
        street = unboxer.unbox(key: "street")
        streetNumber = unboxer.unbox(key: "street_number")
        apartmentNumber = unboxer.unbox(key: "apartment_number")
        comments = unboxer.unbox(key: "comments")
        commentsCount = unboxer.unbox(key: "comments_count")
        normalPrice = unboxer.unbox(key: "normal_price")
        latitude = unboxer.unbox(key: "latitude")
        longitude = unboxer.unbox(key: "longitude")
        mealDescription = unboxer.unbox(key: "meal_description")
        mealCanEatOnSite = unboxer.unbox(key: "meal_can_eat_on_site")
        
        prefetchImages()
    }
    
    func prefetchImages() {
        let urls = [logo, background].flatMap({$0}).map{URL(string: $0)!}
        let prefetcher = ImagePrefetcher(urls: urls)
        prefetcher.start()
    }
}
