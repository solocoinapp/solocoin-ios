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
        mobileNum = mobileNumber.text!
        guard let _mobileNumber = mobileNumber else {return}
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
            let vc = segue.destination as! OTP2Controller
            vc.mobile = mobileNum
        }
     }
}
