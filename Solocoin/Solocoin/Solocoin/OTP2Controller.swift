//
//  OTP2Controller.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import FirebaseAuth

class OTP2Controller: UIViewController {
 
    // OUTLETS
    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var OTP: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
        mobileNumber.text! = publicVars.mobileNumber
    }
    
    @IBAction func Next(_ sender: Any) {
        guard OTP.text! != "" else{
            print("no otp entered, handle error")//handle this by showing a message or smth
            return
        }
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("no ver id found") //highly unlikely but for safety
            return
        }
        //initialisation for signin
        let verificationCode = OTP.text!
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: verificationCode)
        //signin
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                // User is signed in
                // ...
                self.performSegue(withIdentifier: "SignUpController", sender: self)
            }
          
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpController" {
            _ = segue.destination as! SignUpController
        }
    }
    
}
