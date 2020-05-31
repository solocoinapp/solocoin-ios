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

    var code = ""
    var phone = ""
    @IBOutlet weak var mobileNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
    }

    @IBAction func OTPNext(_ sender: Any) {
        print(mobileNumber.text)
        UserDefaults.standard.set(mobileNumber.text!,forKey: "phone")
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
        let oldphone=mobileNumber.text!
        var found=0
        for chr in oldphone{
            if chr == " " || chr == "-"{
                found=1
            }else{
                if found==0{
                    code+=String(chr)
                }else{
                    phone+=String(chr)
                }
            }
        }
        UserDefaults.standard.set(phone,forKey: "phone")
        UserDefaults.standard.set(code,forKey: "code")
        print("c",code,"p",phone)
        
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
        //if phone.count > 5 { //change according to country
            return true
        //}
        //else {
           //return false
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "OTP2" {
            _ = segue.destination as! OTP2Controller
        }
     }
}
