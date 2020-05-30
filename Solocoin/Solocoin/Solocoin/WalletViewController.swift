//
//  WalletViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var coins: UILabel!
    //all offers
    var offers: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coins.text = UserDefaults.standard.string(forKey: "wallet")
        obtainRewards {
            print("completed")
        }
    }
    
    func obtainRewards(completion: ()->()){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/rewards_sponsors")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("r",json)
                        if let object = json as? [[String:AnyObject]]{
                            for offer in object{
                                let nameOffer = offer["offer_name"] as! String
                                let companyName = offer["company_name"] as! String
                                let terms = offer["terms_and_conditions"] as! String
                                let coins = offer["coins"] as! Int
                                let copcode = offer["coupon_code"] as! String
                                self.offers.append(["offer_name":nameOffer,"company":companyName,"terms":terms,"coins":"\(coins)","coupon_code":copcode])
                            }
                            print(self.offers)
                        }
                    }
                }
            }
        }
        }
        qtask.resume()
        completion()
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
