//
//  OTP2Controller.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import SkyFloatingLabelTextField

class OTP2Controller: UIViewController {
 
    // OUTLETS
    
    var phone = ""
    var code = ""
    var uuid = ""
    var idtoken = ""
    var responseCode = 0
    @IBOutlet weak var mobileNumber: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var isIncorrect: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var OTP: OTPTextField!
    @IBOutlet weak var resendOTP: UILabel!
    
    //tapgest
    @IBOutlet weak var tapGest: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isIncorrect.isHidden = true
        /*tapGest = UITapGestureRecognizer(target: self, action: #selector(self.resendCode(_:)))
        tapGest.numberOfTapsRequired = 1
        tapGest.isEnabled = true
        resendOTP.addGestureRecognizer(tapGest)*/
        
        resendOTP.adjustsFontSizeToFitWidth = true
        //tapGest.addTarget(self, action: #selector(resendCode(_:)))
        continueBtn.layer.cornerRadius = continueBtn.frame.width/20
        mobileNumber.placeholder = "Phone No"
        mobileNumber.titleFont = UIFont(name: "Poppins-SemiBold", size: 12)!
        mobileNumber.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        mobileNumber.title = "Phone No"
        mobileNumber.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        //mobileNumber.iconImage = UIImage(imageLiteralResourceName: "ic_mob")
        //let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        //view.addGestureRecognizer(endEditing)
        mobileNumber.text! = publicVars.mobileNumber
        //mobileNumber.isEnabled = false
        //mobileNumber.isUserInteractionEnabled = false
        OTP.configure()
        OTP.didEnterLastDigit = { [weak self] code in
            print(code)
            //finished text
        }
    }
    
<<<<<<< HEAD
    @IBAction func Next(_ sender: Any) {
        guard OTP.text! != "" else{
            print("no otp entered, handle error")//handle this by showing a message or something
            return
        }
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("no ver id found") //highly unlikely but for safety
            return
        }
        signIn {
            let url = URL(string: "https://solocoin.herokuapp.com/api/v1/callbacks/mobile_login")!
            var request = URLRequest(url: url)
            // Specify HTTP Method to use
            request.httpMethod = "POST"
            //sepcifying header
            //let token = UserDefaults.standard.string(forKey: "idtoken")!
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //data
            let content = [
                "user": [
                    "country_code": UserDefaults.standard.string(forKey: "code")!,
                    "mobile": UserDefaults.standard.string(forKey: "phone")!,
                    "uid": publicVars.uuid,//UserDefaults.standard.string(forKey: "uuid")!,
                    "id_token": self.idtoken//UserDefaults.standard.string(forKey: "idtoken")!
                ]
            ]
            let jsonEncoder = JSONEncoder()
            if let jsonData = try? jsonEncoder.encode(content),
                let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                request.httpBody = jsonData
                let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error == nil{
                        // Read HTTP Response Status code
                        if let response = response as? HTTPURLResponse {
                            print("Response HTTP Status code: \(response.statusCode)")
                            if response.statusCode == 200{
                                //user exists and has been logged in
                                if let data = data{
                                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                        print("j",json)
                                        if let object = json as? [String:AnyObject]{
                                            let auth_token = object["auth_token"] as! String
                                            UserDefaults.standard.set(auth_token,forKey: "authtoken")
                                            //perform segue to dahsboard
                                            let username = object["name"] as! String
                                            UserDefaults.standard.set(username, forKey: "username")
                                            guard let lat = object["lat"] as? CLLocationDegrees else{
                                                print("nope lat")
                                                return
                                            }
                                            guard let lang = object["lng"] as? CLLocationDegrees else {
                                                print("nope lang")
                                               return
                                            }
                                            let location = CLLocation(latitude: lat, longitude: lang)
                                            //UserDefaults.standard.set(location, forKey: "homeloc")
                                            publicVars.homeloc = location
                                            DispatchQueue.main.async {
                                                 self.performSegue(withIdentifier: "straightDash", sender: nil)
=======
    @IBAction func resendOTPCode(_ sender: Any) {
        print("hmm")
               if self.resendOTP.text! == "Resend OTP"{
                   print("yes")
                   PhoneAuthProvider.provider().verifyPhoneNumber(self.mobileNumber.text!, uiDelegate: nil) { (verificationID, error) in
                       if let error = error {
                           print("errresend",error.localizedDescription)
                         return
                       }
                       print("np")
                       var limit = 90
                       var secs = 0
                       Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                           secs+=1
                           if secs>=31{
                               self.resendOTP.text = "00 : \(limit-secs)"
                           }else if secs==90{
                            timer.invalidate()
                            self.resendOTP.text = "Resend OTP"
                            self.tapGest.isEnabled = true
                           }else{
                               self.resendOTP.text = "01: \(limit-secs)"
                           }
                       }
                   }
               }
               
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
               signIn {(correct) in
                if correct{
                    self.isIncorrect.isHidden = true
                    let url = URL(string: "https://solocoin.herokuapp.com/api/v1/callbacks/mobile_login")!
                    var request = URLRequest(url: url)
                    // Specify HTTP Method to use
                    request.httpMethod = "POST"
                    //sepcifying header
                    //let token = UserDefaults.standard.string(forKey: "idtoken")!
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    //data
                    let content = [
                        "user": [
                            "country_code": UserDefaults.standard.string(forKey: "code")!,
                            "mobile": UserDefaults.standard.string(forKey: "phone")!,
                            "uid": publicVars.uuid,//UserDefaults.standard.string(forKey: "uuid")!,
                            "id_token": self.idtoken//UserDefaults.standard.string(forKey: "idtoken")!
                        ]
                    ]
                    let jsonEncoder = JSONEncoder()
                    if let jsonData = try? jsonEncoder.encode(content),
                        let jsonString = String(data: jsonData, encoding: .utf8) {
                        print(jsonString)
                        request.httpBody = jsonData
                        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                            if error == nil{
                                // Read HTTP Response Status code
                                if let response = response as? HTTPURLResponse {
                                    print("Response HTTP Status code: \(response.statusCode)")
                                    if response.statusCode == 200{
                                        //user exists and has been logged in
                                        if let data = data{
                                            if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                                print("j",json)
                                                if let object = json as? [String:AnyObject]{
                                                    let auth_token = object["auth_token"] as! String
                                                    UserDefaults.standard.set(auth_token,forKey: "authtoken")
                                                    //perform segue to dahsboard
                                                    let username = object["name"] as! String
                                                    UserDefaults.standard.set(username, forKey: "username")
                                                    guard let lat = object["lat"] as? CLLocationDegrees else{
                                                        print("nope lat")
                                                        return
                                                    }
                                                    guard let lang = object["lng"] as? CLLocationDegrees else {
                                                        print("nope lang")
                                                       return
                                                    }
                                                    let location = CLLocation(latitude: lat, longitude: lang)
                                                    //UserDefaults.standard.set(location, forKey: "homeloc")
                                                    publicVars.homeloc = location
                                                    DispatchQueue.main.async {
                                                         self.performSegue(withIdentifier: "straightDash", sender: nil)
                                                    }
                                                   
                                                }
>>>>>>> 644ee1bce7a0d68924179d7951f106f27aa1032b
                                            }
                                        }
                                    }else if response.statusCode == 401{
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "SignUpController", sender: self)
                                        }
                                    }
                                }
                                
                            }else{
                                print("error",error?.localizedDescription)
                            }
                        }
                        qtask.resume()
                    }
                }else{
                    self.isIncorrect.isHidden = false
                    //self.OTP.clearText()
                }
                   
                   //self.performSegue(withIdentifier: "SignUpController", sender: self)
               }
    }
    @objc func resendCode(_ gesture: UITapGestureRecognizer){
    }
    
    /*func processPhone(completion: () -> ()){
        let oldphone=UserDefaults.standard.string(forKey: "phone")!
        var found=0
        for chr in oldphone{
            if chr == " " && chr == "-"{
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
        print(code,phone)
        completion()
    }*/
    
    func signIn(completion: @escaping (Bool) -> Void){
        var correct = false
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
        let userGroup = DispatchGroup()
        let group2 = DispatchGroup()
        Auth.auth().signIn(with: credential) { (authResult, error) in
            //userGroup.enter()
            if error != nil{
                print(error?.localizedDescription)
                correct = false
            }else{
               // User is signed in
               // ...
                correct = true
                let uuid = authResult?.user.uid
                UserDefaults.standard.set(uuid,forKey: "uuid")
                publicVars.uuid = uuid!
                print("u",uuid)
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        // Handle error
                        print("erroorororo")
                        return
                    }
                    //self.idtoken = idToken!
                    publicVars.idtoken = self.idtoken
                    UserDefaults.standard.set(idToken,forKey: "idtoken")
                    print("ddd \(UserDefaults.standard.string(forKey: "uuid")!)")
                    self.idtoken = UserDefaults.standard.string(forKey: "idtoken")!
                    self.uuid = UserDefaults.standard.string(forKey: "uuid")!
               }
            }
            //userGroup.leave()
            /*userGroup.notify(queue: DispatchQueue.global()) {
                print("done")
                completion()
            }*/
            completion(correct)
       }
        /*userGroup.notify(queue: DispatchQueue.global()) {
            print("done")
            completion()
        }*/
        
        
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpController" {
            _ = segue.destination as! SignUpController
        }
    }
}
