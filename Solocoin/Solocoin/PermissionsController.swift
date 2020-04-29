//
//  PermissionsController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/27/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import MapKit

class PermissionsController: UIViewController {

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func locationAllowed(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    @IBAction func notificationAllowed(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound,]) { (granted, error) in
    
        }
        if publicVars.showNotifications == true {
        let content = UNMutableNotificationContent()
        content.title = "Notifications like this"
        content.body = "This is how notifications will come from SoloCoin"
        
        let date = Date().addingTimeInterval(0)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            // Check the error parameter
        }
        }
        
    }
    
}
