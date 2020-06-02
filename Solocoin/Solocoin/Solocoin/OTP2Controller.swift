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

class OTP2Controller: UIViewController {
 
    // OUTLETS
    
    var phone = ""
    var code = ""
    var uuid = ""
    var idtoken = ""
    var responseCode = 0
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
        signIn {
            let url = URL(string: "https://solocoin.herokuapp.com/api/v1/callbacks/mobile_login")!
            var request = URLRequest(url: url)
            // Specify HTTP Method to use
            request.httpMethod = "POST"
            //sepcifying header
            let token = UserDefaults.standard.string(forKey: "idtoken")!
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //data
            let content = [
                "user": [
                    "country_code": UserDefaults.standard.string(forKey: "code")!,
                    "mobile": UserDefaults.standard.string(forKey: "phone")!,
                    "uid": UserDefaults.standard.string(forKey: "uuid")!,
                    "id_token": UserDefaults.standard.string(forKey: "idtoken")!
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
            //self.performSegue(withIdentifier: "SignUpController", sender: self)
        }
        
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
    
    func signIn(completion: () -> ()){
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
                let uuid = authResult?.user.uid
                UserDefaults.standard.set(uuid,forKey: "uuid")
                print("u",uuid)
                let currentUser = Auth.auth().currentUser
                currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        // Handle error
                        return
                    }
                    UserDefaults.standard.set(idToken,forKey: "idtoken")
                    self.idtoken = UserDefaults.standard.string(forKey: "idtoken")!
                    self.uuid = UserDefaults.standard.string(forKey: "uuid")!
               }
           }
         
       }
        completion()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpController" {
            _ = segue.destination as! SignUpController
        }
    }
    
}
