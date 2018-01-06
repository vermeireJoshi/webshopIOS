import CoreLocation

class LocationManager: CLLocationManager {
 
    init() {
        self.delegate = self
        self.desiredAccuracy = kCLLocationAccuracyBest
    }
}
