//
//  OfferDetailsViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/31/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OfferDetailsViewController: UIViewController {

    @IBOutlet weak var finalNote: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var coins: UILabel!
    var offer:[String:String] = UserDefaults.standard.dictionary(forKey: "offerDict")! as! [String:String]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coins.text = offer["coins"]
        let company = offer["company"] as! String
        finalNote.text = "Please note for any clarification, the final discretion lies with the official staff at \(company)"
        print("id",offer["id"])
    }
    
    @IBAction func claimReward(_ sender: Any) {
        getReward()
    }
    func getReward(){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/redeem_rewards")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "POST"
        //sepcifying header
        let authtoken = "Token \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let content = [
            "rewards_sponsor_id": offer["id"]
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
                            print("j",json)
                        }
                    }
                }else{
                    print("error",error?.localizedDescription)
                }
                
            }
            qtask.resume()
        }
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
