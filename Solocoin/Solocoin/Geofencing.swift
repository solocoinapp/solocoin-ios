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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let currentLocation = locationManager.location
    //    if currentLocation != nil {
            let userLongitude = currentLocation?.coordinate.longitude
            let userLatitude = currentLocation?.coordinate.latitude
        
            let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(userLatitude!, userLongitude!), radius: 1, identifier: "home")

            locationManager.startMonitoring(for: geoFenceRegion)
     //   }
    }
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    
    func showNotification(title: String, message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default
        let request = UNNotificationRequest(identifier: "notif", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension Geofencing: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        GeoFencing.showsUserLocation = true
        }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let title = "You Entered the Region"
        let message = "Wow theres cool stuff in here! YAY!"
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let title = "You Left the Region"
        let message = "Say bye bye to all that cool stuff. =["
        showAlert(title: title, message: message)
        showNotification(title: title, message: message)
    }
    

    
}
