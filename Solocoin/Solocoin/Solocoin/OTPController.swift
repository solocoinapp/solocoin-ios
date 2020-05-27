//
//  OTPController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/24/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import AuthenticationServices
import FirebaseAuth

class OTPController: UIViewController {

    var mobileNum = ""
    
    @IBOutlet weak var mobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
    }

    @IBAction func OTPNext(_ sender: Any) {
        print(mobileNumber.text)
        guard let _ = mobileNumber else {
            return
        }
        //removing spaces if any in mobile number
        var realno=""
        for chr in mobileNumber.text!{
            if chr != " " && chr != "-"{
                realno+=String(chr)
            }
        }
        
        publicVars.mobileNumber = realno
        if isValidMobile(phone: publicVars.mobileNumber) == true {
            //from firebase doc, we're verifying the phone number here and getting the provate veri code from firebase
            PhoneAuthProvider.provider().verifyPhoneNumber(realno, uiDelegate: nil) { (verificationID, error) in
              if let error = error {
                //self.showMessagePrompt(error.localizedDescription) //error handling function, just printing it to console for now
                print("error",error.localizedDescription)
                return
              }
              // Sign in using the verificationID and the code sent to the user
              // ...
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.performSegue(withIdentifier: "OTP2", sender: self)
            }
           }
       }

    func isValidMobile(phone: String) -> Bool {
        if phone.count > 5 { //change accroding to country
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
