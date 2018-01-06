import Alamofire
import ObjectMapper

class CartService {
    
    static let url = "https://webshopbackend.herokuapp.com/products/"
    static var cart = [Product: Int]()
    
    static func addToCart(product: Product) {
        var amount = cart[product]
        
        if amount == nil {
            amount = 0
        }
        
        cart.updateValue(amount! + 1, forKey: product)
        
    }
    
    static func getKeys() -> [Product] {
        var output = [Product]()
        
        for item in cart {
            output.append(item.key)
        }
        
        return output
    }
    
    static func getAmount(product: Product) -> Int {
        return cart[product]!
    }
    
    static func getTotalamount() -> Int {
        var amount: Int = 0
        
        for item in getKeys() {
            amount += cart[item]!
        }
        
        return amount
    }
    
    static func removeProduct(product: Product) {
        cart.removeValue(forKey: product)
    }
    
    static func getTotalPrice() -> Double {
        var output: Double = 0
        
        for item in cart {
            output += (item.key.price! * Double(item.value))
        }
        
        return output
    }
    
    static func printBasket() {
        for item in cart {
            print("\(item.key.name!): \(item.value)")
        }
    }
    
    static func order(succes: @escaping () -> Void, failure: @escaping (_ error: Any) -> Void) {
        var product: [String: AnyObject]
        var productList = [[String: AnyObject]]()
        
        for item in getKeys() {
            product = [
                "product": item._id! as AnyObject,
                "amount": cart[item]! as AnyObject
            ]
            
            productList.append(product)
        }
        
        let parameters: Parameters = [
            "user": UserService.getUserInfo().1,
            "products": NSArray(array: productList),
            "totalPrice": getTotalPrice()
        ]
        
        let headers = [
            "Authorization": "Bearer " + UserService.getUserInfo().0
        ]
        
        Alamofire.request(url + "order", method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if(response.result.isSuccess) {
                cart = [Product: Int]()
                succes()
            } else {
                failure("Could not connect to server. Check your internet connection.")
            }
        }
    }
}

