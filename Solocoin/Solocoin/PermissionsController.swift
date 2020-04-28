//
//  PermissionsController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/27/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import UserNotifications

class PermissionsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func notificationAllowed(_ sender: Any) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound,]) { (granted, error) in
    
        }
        /*
        let content = UNMutableNotificationContent()
        content.title = "You have gone out of the geofenced area"
        content.body = "Please go back inside, unless it is an essential need, in which case we will give you solocoins."
        
        let date = Date().addingTimeInterval(10)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            // Check the error parameter
        }
        */
        
    }
    
}
