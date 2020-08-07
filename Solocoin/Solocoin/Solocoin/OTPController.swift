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
    
    //popup
    @IBOutlet weak var popupParent: UIView!
    @IBOutlet weak var bodyPop: UIView!
    @IBOutlet weak var topMssg: UILabel!
    @IBOutlet weak var mainMssg: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    //backImage
    @IBOutlet weak var backimag: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //making backbtn
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped(_:)))
        backimag.addGestureRecognizer(backTap)
        backimag.isUserInteractionEnabled = true
        
        actionBtn.titleLabel?.adjustsFontSizeToFitWidth = true
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
        mobileNumber.addBottomBorder()
        mobileNumber.textAlignment = .justified
        //setLayout()
        //setting popip
        popupParent.alpha = 0
        popupParent.isUserInteractionEnabled = false
        actionBtn.layer.cornerRadius = actionBtn.frame.width/25
        popupParent.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)

        overrideUserInterfaceStyle = .light
            
        }
        
        func showPopup(){
            self.mainMssg.text = "Verify the mobile number \(self.mobileNumber.selectedCountry!.phoneCode + mobileNumber.text!) and confirm"
            UIView.animate(withDuration: 0.5) {
                self.popupParent.alpha = 1.0
                self.popupParent.isUserInteractionEnabled = true
                self.bodyPop.alpha = 1
                self.bodyPop.isUserInteractionEnabled = true
            }
        }
        
       /* func setLayout(){
            mobileNumber1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
            mobileNumber1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
            mobileNumber1.topAnchor.constraint(equalTo: entermssg.bottomAnchor, constant: 15).isActive = true
            
            
        }*/

        @IBAction func OTPNext(_ sender: Any) {
            showPopup()
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
        @IBAction func sendConfirm(_ sender: Any) {
                self.mainMssg.text = "Verify the mobile number \(self.mobileNumber.selectedCountry!.phoneCode + self.mobileNumber.text!) and confirm"
                UIView.animate(withDuration: 0.5) {
                    self.popupParent.alpha = 0
                    self.popupParent.isUserInteractionEnabled = false
                    self.bodyPop.alpha = 0
                    self.bodyPop.isUserInteractionEnabled = false
                    print(self.mobileNumber.text!)
                    UserDefaults.standard.set(self.mobileNumber.text!,forKey: "phone")
                    guard let _ = self.mobileNumber else {
                        return
                    }
                    self.phone = ""
                    for chr in self.mobileNumber.text!{
                        if chr != " " && chr != "-"{
                            self.phone+=String(chr)
                        }
                    }
                    UserDefaults.standard.set(self.phone,forKey: "phone")
                    UserDefaults.standard.set(self.mobileNumber.selectedCountry?.phoneCode,forKey: "code")
                    print("c",self.mobileNumber.selectedCountry?.phoneCode,"p",self.phone)
                    var realno = self.mobileNumber.selectedCountry!.phoneCode+self.phone
                    
                    publicVars.mobileNumber = realno
                    if self.isValidMobile(phone: publicVars.mobileNumber) == true {
                        //from firebase doc, we're verifying the phone number here and getting the provate veri code from firebase
                        PhoneAuthProvider.provider().verifyPhoneNumber(realno, uiDelegate: nil) { (verificationID, error) in
                          if let error = error {
                            //self.showMessagePrompt(error.localizedDescription) //error handling function, just printing it to console for now
                            if error.localizedDescription == "The interaction was cancelled by the user."{
                                self.mainMssg.text = "Pls complete the recaptcha"
                                self.topMssg.text = "Incomplete"
                                self.actionBtn.titleLabel?.text = "Try Again"
                                UIView.animate(withDuration: 0.5) {
                                    self.popupParent.alpha = 1.0
                                    self.popupParent.isUserInteractionEnabled = true
                                    self.bodyPop.alpha = 1
                                    self.bodyPop.isUserInteractionEnabled = true
                                }
                            }else{
                                self.mainMssg.text = "You seem to have lost Internet Connection"
                                self.topMssg.text = "Connectivity"
                                self.actionBtn.titleLabel?.text = "Try Again"
                                UIView.animate(withDuration: 0.5) {
                                    self.popupParent.alpha = 1.0
                                    self.popupParent.isUserInteractionEnabled = true
                                    self.bodyPop.alpha = 1
                                    self.bodyPop.isUserInteractionEnabled = true
                                }
                            }
                            
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

            
        }
    @IBAction func cancelPop(_ sender: Any) {
            UIView.animate(withDuration: 0.5) {
                self.popupParent.alpha = 0
                self.popupParent.isUserInteractionEnabled = false
                self.bodyPop.alpha = 0
                self.bodyPop.isUserInteractionEnabled = false
            }
        }
    
    @objc func backTapped(_ gesture: UITapGestureRecognizer){
        performSegue(withIdentifier: "backIntro", sender: nil)
        UserDefaults.standard.removeObject(forKey: "phone")
        UserDefaults.standard.removeObject(forKey: "code")
        publicVars.mobileNumber = ""
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

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 255/255, green: 36/255, blue: 72/255, alpha: 1).cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
