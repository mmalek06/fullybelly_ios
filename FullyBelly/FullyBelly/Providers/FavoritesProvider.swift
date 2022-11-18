import Foundation
import SwiftyUserDefaults

struct FavoritesProviders {
    static func favorites() -> [Int]? {
        return Defaults[.favorites].isEmpty ? nil : Defaults[.favorites]
    }
    
    static func favoritesStrings() -> [String]? {
        return Defaults[.favorites].isEmpty ? nil : Defaults[.favorites].map {String($0)}
    }
    
    static func isFavorite(restaurant: Int) -> Bool {
        let filtered = Defaults[.favorites].filter({$0 == restaurant})
        return !filtered.isEmpty
    }
    
    static func addFavorite(restaurant: Int) {
        Defaults[.favorites].append(restaurant)
    }
    
    static func removeFavorite(restaurant: Int) {
        if let index = Defaults[.favorites].index(of: restaurant) {
            Defaults[.favorites].remove(at: index)
        }
    }
}
