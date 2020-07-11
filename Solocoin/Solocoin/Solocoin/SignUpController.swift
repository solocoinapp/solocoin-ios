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
    
    //popup
    @IBOutlet weak var popupParent: UIView!
    @IBOutlet weak var bodyPop: UIView!
    @IBOutlet weak var topMssg: UILabel!
    @IBOutlet weak var mainMssg: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    @IBOutlet weak var declaration: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = createBtn.frame.width/30
        //tandc and pp
        declaration.isSelectable = true
        let attributedString = NSMutableAttributedString(string: "By creating an account you agree to our Terms of Service and Privacy Policy")
        attributedString.addAttribute(.link, value: "https://www.solocoin.app/terms-and-conditions/", range: NSRange(location: 40, length: 16))
        attributedString.addAttribute(.link, value: "https://www.solocoin.app/privacy-policy/", range: NSRange(location: 61, length: 14))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 75))
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: 75))
        declaration.attributedText = attributedString
        
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
        fullName.placeholder = "Fullname"
        fullName.titleFont = UIFont(name: "Poppins-SemiBold", size: 12)!
        fullName.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        fullName.title = "Fullname"
        fullName.tintColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        self.fullName.delegate = self
        popupParent.alpha = 0
               popupParent.isUserInteractionEnabled = false
               actionBtn.layer.cornerRadius = actionBtn.frame.width/25
               popupParent.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        NetworkManager.isReachable { (_) in
            self.topMssg.text = "Connectivity"
            self.mainMssg.text = "No internet Connection"
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
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
        let url = URL(string: "https://prod.solocoin.app/api/v1/callbacks/mobile_sign_up")!
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
                    self.showPopup()
                }
                
            }
            qtask.resume()
        }
        
        // SEGUE
       // performSegue(withIdentifier: "permissionSegue", sender: self)
    }
    
    func showPopup(){
        //self.mainMssg.text = "Verify the mobile number \(self.mobileNumber.selectedCountry!.phoneCode + mobileNumber.text!) and confirm"
        UIView.animate(withDuration: 0.5) {
            self.popupParent.alpha = 1.0
            self.popupParent.isUserInteractionEnabled = true
            self.bodyPop.alpha = 1
            self.bodyPop.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
                self.popupParent.alpha = 0
                self.popupParent.isUserInteractionEnabled = false
                self.bodyPop.alpha = 0
                self.bodyPop.isUserInteractionEnabled = false
            }
        }
    
    @IBAction func actionAct(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
                self.popupParent.alpha = 0
                self.popupParent.isUserInteractionEnabled = false
                self.bodyPop.alpha = 0
                self.bodyPop.isUserInteractionEnabled = false
            }
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
