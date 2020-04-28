//
//  Geofencing.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/27/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class Geofencing: UIViewController {

    @IBOutlet weak var GeoFencing: MKMapView!
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        GeoFencing.showsUserLocation = true
    
        
        let currentLocation = locationManager.location
        if currentLocation != nil {
            let userLongitude = currentLocation?.coordinate.longitude
            let userLatitude = currentLocation?.coordinate.latitude
        
            let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(userLatitude!, userLongitude!), radius: 1, identifier: "home")

            locationManager.startMonitoring(for: geoFenceRegion)
        }
    }
    
    func showAlert() {}

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            print ("\(String(describing: index)): \(currentLocation)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "You have gone out of the geofenced area"
        content.body = "Please go back inside, unless it is an essential need, in which case we will give you solocoins."
        
        let date = Date().addingTimeInterval(0)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            // Check the error parameter
        }
    }

}
