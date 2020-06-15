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

class PermissionsController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var confBtn: UIButton!
    @IBOutlet weak var reload: UIImageView!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var mapViewCrn: MKMapView!
    
    var rotated = false
    var locationManager = CLLocationManager()
    var currentLocation = ""
    var locationObtained = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(reload(_:)))
        reload.addGestureRecognizer(tapGest)
        reload.isUserInteractionEnabled = true
        tapGest.isEnabled = true
        mapViewCrn.layer.cornerRadius = mapViewCrn.frame.width/25
        mapViewCrn.borderColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
        mapViewCrn.borderWidth = 2
        confBtn.layer.cornerRadius = confBtn.frame.width/20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
    }
    
    @objc func reload(_ gesture: UITapGestureRecognizer){
        print("inin")
        UIView.animate(withDuration: 1.0) {
            if !(self.rotated){
                 self.reload.transform = CGAffineTransform(rotationAngle: .pi)
                self.rotated = true
            }else{
                self.reload.transform = CGAffineTransform(rotationAngle: 2*(.pi))
            }
            
            //self.reload.transform = CGAffineTransform(rotationAngle: 2*(.pi))
        }
        
        determineCurrentLocation()
    }
    
    /*@IBAction func locationAllowed(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }*/
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        locationObtained = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapViewCrn.setRegion(mRegion, animated: true)

        // Get user's Current Location and Drop a pin
    let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        mapViewCrn.addAnnotation(mkAnnotation)
        publicVars.homeloc = CLLocation(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        //UserDefaults.standard.set(CLLocation(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude),forKey: "homeloc")
    }
    //MARK:- Intance Methods

    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in

            if let mPlacemark = placemarks{
                if let dict = mPlacemark[0].addressDictionary as? [String: Any]{
                    if let Name = dict["Name"] as? String{
                        if let City = dict["City"] as? String{
                            self.locationField.text = Name + ", " + City
                            self.currentLocation = Name + ", " + City
                        }
                    }
                }
            }
        }
        print("ll",currentLocation)
        return currentLocation
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
    
    @IBAction func confirmLoc(_ sender: Any) {
    }
}

