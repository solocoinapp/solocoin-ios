//
//  SignUpController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//
import UIKit
import CoreLocation
import SkyFloatingLabelTextField

class SignUpController: UIViewController,UITextFieldDelegate {

    // MARK: - IBOUTLETS
    @IBOutlet weak var fullName: SkyFloatingLabelTextFieldWithIcon!

    //@IBOutlet weak var signUpEmail: UITextField!
    
    //@IBOutlet weak var signUpGender: UISegmentedControl!
    
    //@IBOutlet weak var signUpBirth: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //signUpGender.selectedSegmentIndex = 0
        //publicVars.genderSignUp = signUpGender.titleForSegment(at: 0) ?? "error"
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
        fullName.placeholder = "Fullname"
        fullName.titleFont = UIFont(name: "Poppins-SemiBold", size: 12)!
        fullName.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        fullName.title = "Phone No"
        fullName.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        self.fullName.delegate = self
        
    }
    
    /*@IBAction func genderClicked(_ sender: Any) {
        publicVars.hasGender = true
        publicVars.whichGenderSegment = signUpGender.selectedSegmentIndex
    }*/

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func accountCreated(_ sender: Any) {
        // VARIABLES
        publicVars.fullNameSignUp = fullName.text!
        //publicVars.emailSignUp = signUpEmail.text!
        /*if publicVars.hasGender == true {
            publicVars.genderSignUp = signUpGender.titleForSegment(at: publicVars.whichGenderSegment) ?? "error"
            print(publicVars.genderSignUp)
        }*/
        // BIRTH
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -100
        //signUpBirth.minimumDate = calendar.date(byAdding: components, to: currentDate)
        //signUpBirth.maximumDate = calendar.date(byAdding: components, to: currentDate)
        
        //API
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/callbacks/mobile_sign_up")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let token = UserDefaults.standard.string(forKey: "idtoken")!
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //data
        let content = [
            "user": [
                "name": fullName.text!,
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
                /*if error == nil{
                    // Read HTTP Response Status code
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                    }
                    print(data)
                    
                }else{
                    print("error",error?.localizedDescription)
                    if error == nil{
                    // Read HTTP Response Status code
                        if let response = response as? HTTPURLResponse {
                            print("Response HTTP Status code: \(response.statusCode)")
                    }
                        print("dad",data)
                }
            }*/
                if error == nil{
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                        if response.statusCode == 200 {
                            if let data = data{
                                if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                                    print("j",json)
                                    if let object = json as? [String:AnyObject]{
                                        let auth_token = object["auth_token"] as! String
                                        UserDefaults.standard.set(auth_token,forKey: "authtoken")
                                        DispatchQueue.main.async {
                                            UserDefaults.standard.set(self.fullName.text!, forKey: "username")
                                        }
                                       /* guard let lat = object["lat"] as? CLLocationDegrees else{
                                            print("nope lat")
                                            return
                                        }
                                        guard let lang = object["lng"] as? CLLocationDegrees else {
                                            print("nope lang")
                                           return
                                        }
                                        let location = CLLocation(latitude: lat, longitude: lang)
                                        //UserDefaults.standard.set(location, forKey: "homeloc")
                                        publicVars.homeloc = location*/
                                        //perform segue to dahsboard
                                        DispatchQueue.main.async {
                                            self.performSegue(withIdentifier: "permissionSegue", sender: self)
                                        }
                                       
                                    }
                                }
                            }
                        }
                    }
                }else{
                    print("error",error?.localizedDescription)
                }
                
            }
            qtask.resume()
        }
        
        // SEGUE
       // performSegue(withIdentifier: "permissionSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func signIn(completion: () -> ()){
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            print("no ver id found") //highly unlikely but for safety
            return
        }
        
        //initialisation for signin
        completion()
        
    }
}
