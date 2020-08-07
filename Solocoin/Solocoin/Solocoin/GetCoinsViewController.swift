//
//  GetCoinsViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 8/7/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class GetCoinsViewController: UIViewController {
    
    @IBOutlet weak var headerBar: UINavigationBar!
    @IBOutlet weak var solocoinImage: UIImageView!
    @IBOutlet weak var mainpic: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var couponField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var back: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        back.isHidden = true
        solocoinImage.translatesAutoresizingMaskIntoConstraints = false
        mainpic.translatesAutoresizingMaskIntoConstraints = false
        infoText.translatesAutoresizingMaskIntoConstraints = false
        couponField.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        back.translatesAutoresizingMaskIntoConstraints = false
        setLayout()
        nextButton.layer.cornerRadius = nextButton.frame.width/25
    }
    
    func setLayout(){
        solocoinImage.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: view.frame.height/25).isActive = true
        solocoinImage.heightAnchor.constraint(equalToConstant: view.frame.height/8).isActive = true
        solocoinImage.widthAnchor.constraint(equalToConstant: view.frame.width/4).isActive = true
        solocoinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainpic.topAnchor.constraint(equalTo: solocoinImage.bottomAnchor, constant: view.frame.height/15 ).isActive = true
        mainpic.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainpic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainpic.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        infoText.topAnchor.constraint(equalTo: mainpic.bottomAnchor, constant: 8).isActive = true
        infoText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        //infoText.heightAnchor.constraint(equalToConstant: self.view.frame.height/16.8).isActive = true
        couponField.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: self.view.frame.height/31).isActive = true
        couponField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        couponField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        couponField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: couponField.bottomAnchor, constant: self.view.frame.height/26).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: view.frame.height/15).isActive = true
        //nextButton.topAnchor.constraint(greaterThanOrEqualTo: infoText.bottomAnchor, constant: view.frame.height/15).isActive = true
        back.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 8).isActive = true
        back.widthAnchor.constraint(equalToConstant: nextButton.frame.width/6).isActive = true
        back.heightAnchor.constraint(equalToConstant: nextButton.frame.height/1.5).isActive = true
        back.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //skip.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        back.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
    
    @IBAction func redeemCode(_ sender: Any) {
        guard couponField.text != "" else {
            couponField.errorMessage = "Invalid Code"
            return
        }
        getCoins(couponCode: couponField.text!) {
            print("made judgement")
        }
    }
    
    func getCoins(couponCode: String, completion: @escaping()->()){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/coin_codes/valid_coupon")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let content = [
            "coupon": couponCode
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
                        if let data = data{
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                            print("coupon referral",json)
                           /* if let object = json as? [String:AnyObject]{
                                let name = object["name"] as! String
                                publicVars.username = name
                                UserDefaults.standard.set(name,forKey: "name")
                                let pic = object["profile_picture_url"] as! String
                                UserDefaults.standard.set(pic,forKey: "pic")
                                if let wallet_balance = object["wallet_balance"] as? String{
                                    UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                                }else if let wallet_balance = object["wallet_balance"] as? Int{
                                    UserDefaults.standard.set("\(wallet_balance)",forKey: "wallet")
                                }
                                print("sdfsd redeeemsd", object["redeemed_rewards"])
                                if let redeemed = object["redeemed_rewards"] as? [[String:AnyObject]]{
                                    print("could convert redeemed")
                                    if redeemed.count != 0{
                                        self.yes = true
                                    }else{
                                        self.yes = false
                                    }
                                    
                                }else{
                                    print("couldt asdasda")
                                    self.yes = false
                                }
                                /*guard let lat = object["lat"] as? NSString else{
                                    print(object["lat"])
                                    print("nope lat")
                                    return
                                }
                                guard let lang = object["lng"] as? NSString else {
                                    print("nope lang")
                                   return
                                }*/
                                
                            }*/
                            }
                        }
                    }
                }else{
                    print("error",error?.localizedDescription)
                }
                completion()
            }
            qtask.resume()
        }
    }

    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
