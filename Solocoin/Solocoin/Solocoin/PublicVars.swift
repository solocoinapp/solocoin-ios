//
//  PublicVars.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct publicVars {
    
    //MARK: OTP2ControllerVars
    static var mobileNumber: String = ""
    
    //MARK: SignUpControllerVars
    static var fullNameSignUp: String = ""
    static var emailSignUp: String = ""
    static var genderSignUp: String = ""
    static var hasGender: Bool = false
    static var whichGenderSegment: Int = 0
    
    //MARK: GeofencingControllerVars
    static var showNotifications: Bool = false
    
    //MARK: HomePage1
    static var newloc: CLLocation = CLLocation()
    static var homeloc = CLLocation()
    
    //user details
    static var uuid = ""
    static var idtoken = ""

    
}
