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
        
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(userLatitude!, userLongitude!), radius: 200, identifier: "home")

        locationManager.startMonitoring(for: geoFenceRegion)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            print ("\(String(describing: index)): \(currentLocation)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

    }

}
