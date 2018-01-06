import Alamofire
import ObjectMapper

class UserService {
    
    static let url = "https://webshopbackend.herokuapp.com/users/"
    
    static var userToken: String?
    static var username: String?
    
    static func login(username: String, password: String, succes: @escaping () -> Void, failure: @escaping (_ error: Any) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(url + "login", method: .post, parameters: parameters).responseJSON { response in
            if(response.result.isSuccess) {
                if response.response?.statusCode == 401 {
                    failure("Wrong username of password.")
                } else {
                    let json = response.result.value as! [String: Any]
                    
                    self.userToken = json["token"] as? String
                    self.username = username
            
                    succes()
                }
            } else {
                failure("Can't connect to server. Check your internet connection.")
            }
        }
    }
    
    static func register(username: String, password: String, succes: @escaping () -> Void, failure: @escaping (_ error: Any) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(url + "register", method: .post, parameters: parameters).responseJSON { response in
            if(response.result.isSuccess) {
                if response.response?.statusCode == 200 {
                    succes()
                } else {
                    failure("Username already exists.")
                }
            } else {
                failure("Can't connect to server. Check your internet connection.")
            }
        }
    }
    
    static func logout() {
        userToken = ""
        username = ""
    }
    
    static func getUserInfo() -> (String, String) {
        return (userToken ?? "", username ?? "")
    }
}
