//
//  OfferDetailsViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/31/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import SDWebImage
class OfferDetailsViewController: UIViewController {
    
    //popup
    @IBOutlet weak var popupParent: UIView!
    @IBOutlet weak var bodyPop: UIView!
    @IBOutlet weak var topMssg: UILabel!
    @IBOutlet weak var mainMssg: UILabel!
    @IBOutlet weak var actionBtn: UIButton!

    @IBOutlet weak var claimBtn: UIButton!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var tandc: UILabel!
    @IBOutlet weak var finalNote: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var coins: UILabel!
    var offer:[String:Any] = UserDefaults.standard.dictionary(forKey: "offerDict")! as! [String:Any]
    override func viewDidLoad() {
        super.viewDidLoad()
        popupParent.alpha = 0
        popupParent.isUserInteractionEnabled = false
        actionBtn.layer.cornerRadius = actionBtn.frame.width/25
        popupParent.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        // Do any additional setup after loading the view.
        claimBtn.layer.cornerRadius = claimBtn.frame.width/30
        category.text = "Category: \(offer["category"] as! String)"
        tandc.text = offer["terms"] as! String
        tandc.adjustsFontSizeToFitWidth = true
        if (offer["coins"]! as? Int) != nil{
            coins.text = " \(offer["coins"]! as! Int) coins"
        }else{
            coins.text = " \(offer["coins"]! as! String) coins"
        }
        
        let company = offer["company"] as! String
        finalNote.text = "Please note for any clarification, the final discretion lies with the official staff at \(company)"
        if (offer["imgurl"] as! String) != nil && (offer["imgurl"] as! String) != ""{
            let url = URL(string: "https://solocoin.herokuapp.com/\(offer["imgrul"]!)")
            offerImage.sd_setImage(with: url) { (image, error, cache, url) in
                if error == nil{
                    print("got image")
                }else{
                    print("SIKE!....no image haha")
                }
            }
        }
        print("id",offer["id"]!)
    }
    
    @IBAction func claimReward(_ sender: Any) {
        getReward {
            DispatchQueue.main.async {
                self.showPopup()
            }
            
        }
        
    }
    func getReward(completion:@escaping ()->()){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/redeem_rewards")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let content = [
            "rewards_sponsor_id": offer["id"] as! String
        ]
        let jsonEncoder = JSONEncoder()
        if let jsonData = try? jsonEncoder.encode(content),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
            request.httpBody = jsonData
            let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil{
                    
                    if let response = response as? HTTPURLResponse {
                        print("Response HTTP Status code: \(response.statusCode)")
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []){
                            print("coupon",json)
                            if let object = json as? [String:AnyObject]{
                                if object["error"] != nil{
                                    DispatchQueue.main.async {
                                        if object["error"] as! String == "Insufficient coins"{
                                            self.mainMssg.text = "You dont have sufficient coins to redeem"
                                            self.mainMssg.adjustsFontSizeToFitWidth = true
                                        }else{
                                            self.mainMssg.text = "You have already redeemed this coupon"
                                            self.mainMssg.adjustsFontSizeToFitWidth = true
                                        }
                                    }
                                }else{
                                   DispatchQueue.main.async {
                                        let pasteboard = UIPasteboard.general
                                        pasteboard.string = self.offer["coupon_code"] as! String
                                        self.mainMssg.text = "Couponcode has been copied to clipboard"
                                        self.mainMssg.adjustsFontSizeToFitWidth = true
                                    }
                                }
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
        /*@IBAction func ActionAccept(_ sender: Any) {
            UIView.animate(withDuration: 0.5) {
                    self.popupParent.alpha = 0
                    self.popupParent.isUserInteractionEnabled = false
                    self.bodyPop.alpha = 0
                    self.bodyPop.isUserInteractionEnabled = false
                }
            }*/
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

    @IBAction func okBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.popupParent.alpha = 0
            self.popupParent.isUserInteractionEnabled = false
            self.bodyPop.alpha = 0
            self.bodyPop.isUserInteractionEnabled = false
        }) { (check) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func goBacklol(sender: AnyObject){
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
