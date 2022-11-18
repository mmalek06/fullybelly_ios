import XCTest
import Moya
import Alamofire
@testable import FullyBelly

class FullyBellyTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        LocationProvider.shared.supplier = nil
    }
    
    func testQueryString_GetOffers() {
        let exp = expectation(description: "API")
        var request: URLRequest!
        
        let provider = Network.stubProvider
        
        let offerParameters = OffersParameters(favorites: true, favoriteRestaurants: ["abc", "def", "ghi"], availableOffers: true, cheapest: true, closest: true, pickup: true, distance: 10)
        let target = FullyBellyService.getOffers(query: nil, offerParameters: offerParameters)
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                if let responseRequest = response.request {
                    request = responseRequest
                }
            case .failure(_):
                break
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertEqual(request.url?.absoluteString, "https://api.fullybelly.pl/v1/offers/no-location/?cheapest=true&closest=true&distance=10&fav-restaurants=abc%2Cdef%2Cghi&favorites=true&only-available=true&pickup=true")
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.allHTTPHeaderFields!, ["Content-Type":"application/json", "Accept-Language":NSLocale.current.languageCode!, "Accept": "application/json"])
            XCTAssertEqual(request.httpBody, nil)
        }
    }
    
    func testQueryString_PostBookOrder() {
        let exp = expectation(description: "API")
        var request: URLRequest!
        
        let provider = Network.stubProvider
        
        let date = Date()
        let bookOrder = BookOrder(restaurant: 4, email: "test@test.com", pickupTime: date, meal: 4, amount: 2)
        let target = FullyBellyService.postBookOrder(order: bookOrder)
        provider.request(target) { (result) in
            switch result {
            case let .success(response):
                if let responseRequest = response.request {
                    request = responseRequest
                }
            case .failure(_):
                break
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertEqual(request.url?.absoluteString, "https://api.fullybelly.pl/v1/orders/book")
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.allHTTPHeaderFields!, ["Content-Type":"application/json", "Accept-Language":NSLocale.current.languageCode!, "Accept": "application/json"])
            XCTAssertNotEqual(request.httpBody, nil)
            XCTAssertEqual(String(data: request.httpBody!, encoding: String.Encoding.utf8), "{\"restaurant\":4,\"pickup_time\":\"\(date.formatted(format: "yyyy-MM-dd HH:mm:ss"))\",\"meal\":4,\"amount\":2,\"buyer_email\":\"test@test.com\"}")
        }
    }
    
    func testPathGeneration_GetTAC() {
        XCTAssertEqual(FullyBellyService.getTAC().path, "/terms-and-conditions/\(NSLocale.current.languageCode!)")
    }
    
    func testPathGeneration_GetOffers() {
        XCTAssertEqual(FullyBellyService.getOffers(query: "", offerParameters: nil).path, "/offers/no-location/")
        XCTAssertEqual(FullyBellyService.getOffers(query: "Gdynia", offerParameters: nil).path, "/offers/no-location/Gdynia")
        XCTAssertEqual(FullyBellyService.getOffers(query: "Query with spaces", offerParameters: nil).path, "/offers/no-location/Query%20with%20spaces")
        
        LocationProvider.shared.supplier = MockLocationManager(lat: 54.3524671, lon: 18.6555253)
        XCTAssertEqual(FullyBellyService.getOffers(query: "", offerParameters: nil).path, "/offers/54.3524671/18.6555253/")
        XCTAssertEqual(FullyBellyService.getOffers(query: "Gdynia", offerParameters: nil).path, "/offers/54.3524671/18.6555253/Gdynia")
        XCTAssertEqual(FullyBellyService.getOffers(query: "Query with spaces", offerParameters: nil).path, "/offers/54.3524671/18.6555253/Query%20with%20spaces")
    }
    
    func testPathGeneration_GetOfferDetail() {
        XCTAssertEqual(FullyBellyService.getOfferDetail(resturantId: 4, offerId: nil).path, "/offers/detail/no-location/4/0")
        XCTAssertEqual(FullyBellyService.getOfferDetail(resturantId: 4, offerId: 4).path, "/offers/detail/no-location/4/4")
        
        LocationProvider.shared.supplier = MockLocationManager(lat: 54.3524671, lon: 18.6555253)
        XCTAssertEqual(FullyBellyService.getOfferDetail(resturantId: 4, offerId: nil).path, "/offers/detail/54.3524671/18.6555253/4/0")
        XCTAssertEqual(FullyBellyService.getOfferDetail(resturantId: 4, offerId: 4).path, "/offers/detail/54.3524671/18.6555253/4/4")
    }
    
    func testPathGeneration_getOrderMonitor() {
        XCTAssertEqual(FullyBellyService.getOrderMonitor(orderId: "b66b9b26-4d07-4acd-b234-e0e727bc4093").path, "/orders/monitor/b66b9b26-4d07-4acd-b234-e0e727bc4093")
    }
    
    func testPathGeneration_getOrdersList() {
        XCTAssertEqual(FullyBellyService.getOrdersList(email: "test@test.com").path, "/orders/list/test%40test.com")
    }
    
    func testParameters_getOffers1() {
        let offerParameters = OffersParameters(favorites: true, favoriteRestaurants: ["1"], availableOffers: true, cheapest: true, closest: true, pickup: true, distance: 10)
        let target = FullyBellyService.getOffers(query: nil, offerParameters: offerParameters)
        
        XCTAssertEqual(target.parameters!.count, 7)
    }
    
    func testParameters_getOffers2() {
        let offerParameters = OffersParameters(favorites: true, favoriteRestaurants: nil, availableOffers: nil, cheapest: nil, closest: true, pickup: true, distance: 10)
        let target = FullyBellyService.getOffers(query: nil, offerParameters: offerParameters)
        
        XCTAssertEqual(target.parameters!.count, 4)
    }
}

extension Date {
    func formatted(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
