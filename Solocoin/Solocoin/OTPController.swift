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
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
    }

    
    @IBAction func OTPNext(_ sender: Any) {
        guard let _ = mobileNumber else {return}
        publicVars.mobileNumber = mobileNumber.text!
        if isValidMobile(phone: publicVars.mobileNumber) == true {
            performSegue(withIdentifier: "OTP2", sender: self)
           }
       }

    func isValidMobile(phone: String) -> Bool {
        if phone.count == 10 {
            return true
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "OTP2" {
            _ = segue.destination as! OTP2Controller
        }
     }
}
