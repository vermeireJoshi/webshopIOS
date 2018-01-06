import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBe9TI_yLVsvMliMFEu9n3k7MfUyAaYO_w")
        //GMSPlacesClient.provideAPIKey("AIzaSyBe9TI_yLVsvMliMFEu9n3k7MfUyAaYO_w")
        return true
    }
}

