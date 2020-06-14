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
import FlagPhoneNumber

class OTPController: UIViewController {

    var code = ""
    var phone = ""
    @IBOutlet weak var mobileNumber: FPNTextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var mssg: UILabel!
    @IBOutlet weak var entermssg: UILabel!
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBtn.isHidden = true
        nextBtn.layer.cornerRadius = view.frame.width/20
        mobileNumber.delegate = self
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
        mobileNumber.displayMode = .list
        listController.setup(repository: mobileNumber.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.mobileNumber.setFlag(countryCode: country.code)
        }
        mobileNumber.setFlag(key: .IN)
        //mobileNumber.flagButtonSize = CGSize(width: 88, height: 44)
        mobileNumber.flagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mobileNumber.borderColor = .clear
        mobileNumber.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        mobileNumber.translatesAutoresizingMaskIntoConstraints = false
        mssg.translatesAutoresizingMaskIntoConstraints = false
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        //setLayout()
    }
    
    
    
   /* func setLayout(){
        mobileNumber1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        mobileNumber1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        mobileNumber1.topAnchor.constraint(equalTo: entermssg.bottomAnchor, constant: 15).isActive = true
        
        
    }*/

    @IBAction func OTPNext(_ sender: Any) {
        print(mobileNumber.text!)
        UserDefaults.standard.set(mobileNumber.text!,forKey: "phone")
        guard let _ = mobileNumber else {
            return
        }
        //removing spaces if any in mobile number
        /*var realno=""
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
        }*/
        for chr in mobileNumber.text!{
            if chr != " " && chr != "-"{
                phone+=String(chr)
            }
        }
        UserDefaults.standard.set(phone,forKey: "phone")
        UserDefaults.standard.set(mobileNumber.selectedCountry?.phoneCode,forKey: "code")
        print("c",mobileNumber.selectedCountry?.phoneCode,"p",phone)
        var realno = mobileNumber.selectedCountry!.phoneCode+phone
        
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

extension OTPController: FPNTextFieldDelegate {

    func fpnDisplayCountryList() {
       let navigationViewController = UINavigationController(rootViewController: listController)

       listController.title = "Countries"

       self.present(navigationViewController, animated: true, completion: nil)
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        /*textField.rightViewMode = .always
        //textField.rightView = UIImageView(image: isValid ? #imageLiteral(resourceName: "success") : #imageLiteral(resourceName: "error"))

        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )*/
        if isValid{
            textField.getFormattedPhoneNumber(format: .International)
            self.nextBtn.isHidden = false
        }else{
            self.nextBtn.isHidden = true
        }
    }

    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code)
    }
}
