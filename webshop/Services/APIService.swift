import Alamofire
import ObjectMapper
import Foundation

class APIService {
    
    var products: [Product]?
    
    static let url = "https://webshopbackend.herokuapp.com/"
    
    static func getProducts(succes: @escaping (_ response: [Product]) -> Void, failure: @escaping (_ error: Any) -> Void) {
        Alamofire.request(url + "products").responseJSON { response in
            if(response.result.isSuccess) {
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    print("ObjectMapper error")
                    return
                }
                
                guard let products:[Product] = Mapper<Product>().mapArray(JSONArray: responseJSON) else {
                    print("ObjectMapper error")
                    return
                }
                
                succes(products)
            } else {
                failure("Could not connect to server. Check your internet connection.")
            }
        }
    }
    
    static func getLocations(succes: @escaping (_ response: [Location]) -> Void, failure: @escaping (_ error: Any) -> Void) {
        Alamofire.request(url + "location").responseJSON { response in
            if(response.result.isSuccess) {
                guard let responseJSON = response.result.value as? Array<[String: AnyObject]> else {
                    print("ObjectMapper error")
                    return
                }
                
                guard let locations:[Location] = Mapper<Location>().mapArray(JSONArray: responseJSON) else {
                    print("ObjectMapper error")
                    return
                }
                
                succes(locations)
            } else {
                failure("Could not connect to server. Check your internet connection.")
            }
        }
    }
}
