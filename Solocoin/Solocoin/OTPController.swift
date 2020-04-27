//
//  OTPController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/24/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import AuthenticationServices

class OTPController: UIViewController {

    var mobileNum = ""
    
    @IBOutlet weak var mobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func OTPNext(_ sender: Any) {
        guard let _ = mobileNumber else {return}
        var mobileNum = mobileNumber.text!
        if isValidMobile(phone: mobileNum) == true {
            performSegue(withIdentifier: "OTP2", sender: self)
            mobileNum = mobileNumber.text!
           }
       }

    // MARK: FUNCTIONS
    // Checks to see if an phone is valid
    func isValidMobile(phone: String) -> Bool {
        if mobileNum.count == 10 {
            return true
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "OTP2" {
            let OTP2 = segue.destination as! OTP2Controller
            OTP2.mobile = mobileNum
        }
     }
}
