import UIKit
import GoogleMaps
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locations = [Location]()
    var markers =  [GMSMarker]()
    var currentLocation: CLLocation?
    let manager = CLLocationManager()
    var mapView: GMSMapView?
    
    var gotLocations: Bool = false
    var gotCurrentLocation: Bool = false
    
    override func loadView() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manager.startUpdatingLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: 51.054633, longitude: 3.7219431, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        
        if !gotLocations {
            APIService.getLocations(succes: { (response) in
                self.locations = response
                self.addMarkers()
            }, failure: {(response) in
                self.createAlert(message: response as! String)
            })
        } else {
            addMarkers()
        }
    }
    
    func addMarkers() {
        markers = [GMSMarker]()
        
        for loc in locations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: loc.latitude!, longitude: loc.longitude!)
            marker.title = loc.name
            marker.snippet = loc.location
            marker.icon = #imageLiteral(resourceName: "marker")
            marker.map = self.mapView
            self.markers.append(marker)
        }
        
        self.gotLocations = true
        self.calcClosesShop()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        manager.stopUpdatingLocation()
        gotCurrentLocation = true
        calcClosesShop()
    }
    
    func calcClosesShop() {
        if gotLocations && gotCurrentLocation {
            var closes = markers[0]
            var distance = currentLocation?.distance(from:
                CLLocation(latitude: closes.position.latitude, longitude: closes.position.longitude))
            
            for var i in 1...(markers.count - 1) {
                let newDistance = currentLocation?.distance(from:
                    CLLocation(latitude: self.markers[i].position.latitude,
                               longitude: self.markers[i].position.longitude))
                if((newDistance?.magnitude)! < (distance?.magnitude)!) {
                    distance = newDistance
                    closes = markers[i]
                }
            }
            
            closes.icon = #imageLiteral(resourceName: "marker_closes")
            closes.title = closes.title! + " (nearest)"
            
            let camera = GMSCameraPosition.camera(withLatitude: closes.position.latitude, longitude: closes.position.longitude, zoom: 8.0)
            self.mapView?.camera = camera
            
            gotLocations = false
            gotCurrentLocation = false
        }
    }
    
    func createAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
 }


