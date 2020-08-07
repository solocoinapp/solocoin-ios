//
//  ProfilePage.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfilePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    let pp = URL(string: "https://www.solocoin.app/privacy-policy/")
    let turl = URL(string: "https://www.solocoin.app/terms-and-conditions/")
    
    var success = true
    var yes = false
    
    //var profileSettings = ["Profile", "Rewards History", "Invite", "Permissions", "Privacy Policy", "Terms & Conditions"]
    var profileSettings = ["Invite", "Privacy Policy", "Terms & Conditions","User Guide","Redeem Solocoins", "Logout"]
    let gradientLayer = CAGradientLayer()
//    let profileImages: [UIImage] = [#imageLiteral(resourceName: "PeopleIcon"), #imageLiteral(resourceName: "EmailIcon"), #imageLiteral(resourceName: "PermissionIcon"), #imageLiteral(resourceName: "PrivacyPolicyIcon.png"), #imageLiteral(resourceName: "TermsAndConditionsIcon")]
    
    //popup
    
    @IBOutlet weak var headerBar: UIView!
    @IBOutlet weak var popupParent: UIView!
    @IBOutlet weak var bodyPop: UIView!
    @IBOutlet weak var topMssg: UILabel!
    @IBOutlet weak var mainMssg: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting popip
        popupParent.alpha = 0
        popupParent.isUserInteractionEnabled = false
        actionBtn.layer.cornerRadius = actionBtn.frame.width/25
        popupParent.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.separatorColor = UIColor.init(red: 240/255, green: 81/255, blue: 105/255, alpha: 1)
        profileTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        // Do any additional setup after loading the view.
        profileTableView.tableFooterView = UIView()
        profileTableView.tableFooterView?.backgroundColor = .white
        profileTableView.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradientLayer.frame = self.headerBar.bounds
        gradientLayer.colors = [UIColor.init(red: 194/255, green: 57/255, blue: 90/255, alpha: 1).cgColor, UIColor.init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1).cgColor]
        self.headerBar.layer.insertSublayer(gradientLayer, at: 0)
        self.obtainProfileInfo {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if yes{
            return profileSettings.count+1
        }else{
          return profileSettings.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if yes{
            let newprof = ["Redeemed Rewards","Invite", "Privacy Policy", "Terms & Conditions","User Guide","Redeem Solocoins", "Logout"]
            if indexPath.row != 3{
                guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "infoCell") as? profileTableViewCell else {return UITableViewCell()}
                    //cell?.textLabel?.text = profileSettings[indexPath.row]
                    cell.labelMain.text = newprof[indexPath.row]
                    cell.labelMain.adjustsFontSizeToFitWidth = true
                    cell.selectionStyle = .none
                    switch indexPath.row{
                    case 0:
                        cell.indximage.image = UIImage(systemName: "bag.fill")
                    case 1:
                        cell.indximage.image = UIImage(systemName: "envelope.fill")
                    case 2:
                        cell.indximage.image = UIImage(systemName: "checkmark.shield.fill")
                    case 3:
                        cell.indximage.image = UIImage(systemName: "bookmark.fill")
                    case 4:
                        cell.indximage.image = UIImage(systemName: "book.fill")
                    case 5:
                        cell.indximage.image = UIImage(systemName: "circle.grid.2x2.fill")
                    case 6:
                        cell.indximage.image = UIImage(systemName: "arrowshape.turn.up.left.2.fill")
                    default:
                        print("nilcell")
                    }
            //        cell?.imageView?.image = profileImages[indexPath.row]
                    return cell
            }else{
                guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "libCell") as? profileTableViewCell else {return UITableViewCell()}
                        
                        //cell?.textLabel?.text = profileSettings[indexPath.row]
                        cell.labelMain.text = profileSettings[indexPath.row]
                        cell.labelMain.adjustsFontSizeToFitWidth = true
                        cell.selectionStyle = .none
                            cell.indximage.image = UIImage(systemName: "bookmark.fill")
                //        cell?.imageView?.image = profileImages[indexPath.row]
                        return cell
            }
        }else{
            if indexPath.row != 2{
                guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "infoCell") as? profileTableViewCell else {return UITableViewCell()}
                        
                        //cell?.textLabel?.text = profileSettings[indexPath.row]
                        cell.labelMain.text = profileSettings[indexPath.row]
                        cell.labelMain.adjustsFontSizeToFitWidth = true
                        cell.selectionStyle = .none
                        switch indexPath.row{
                        case 0:
                            cell.indximage.image = UIImage(systemName: "envelope.fill")
                        case 1:
                            cell.indximage.image = UIImage(systemName: "checkmark.shield.fill")
                        case 2:
                            cell.indximage.image = UIImage(systemName: "bookmark.fill")
                        case 3:
                            cell.indximage.image = UIImage(systemName: "book.fill")
                        case 4:
                            cell.indximage.image = UIImage(systemName: "bag.fill")
                        case 5:
                            cell.indximage.image = UIImage(systemName: "arrowshape.turn.up.left.2.fill")
                        default:
                            print("nilcell")
                        }
                //        cell?.imageView?.image = profileImages[indexPath.row]
                        return cell
            }else{
                guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "libCell") as? profileTableViewCell else {return UITableViewCell()}
                        
                        //cell?.textLabel?.text = profileSettings[indexPath.row]
                        cell.labelMain.text = profileSettings[indexPath.row]
                        cell.labelMain.adjustsFontSizeToFitWidth = true
                        cell.selectionStyle = .none
                            cell.indximage.image = UIImage(systemName: "bookmark.fill")
                //        cell?.imageView?.image = profileImages[indexPath.row]
                        return cell
            }
        }
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if yes{
            switch indexPath.row{
            case 0:
                self.performSegue(withIdentifier: "showRedeemed", sender: nil)
            case 1:
                print("Invite")
                invite()
            case 2:
                print("")
                goURl(type: 0)
            case 3:
                print("")
                goURl(type: 1)
            case 4:
                goURl(type: 2)
            case 5:
                self.performSegue(withIdentifier: "redeemCoins", sender: nil)
            case 6:
                print("")
                showPopup()
            default:
                print("")
            }
        }else{
            switch indexPath.row{
            case 0:
                print("Invite")
                invite()
            case 1:
                print("")
                goURl(type: 0)
            case 2:
                print("")
                goURl(type: 1)
            case 3:
                goURl(type: 2)
            case 4:
                self.performSegue(withIdentifier: "redeemCoins", sender: nil)
            case 5:
                print("")
                showPopup()
            default:
                print("")
            }
        }
        
    }
    
    func showPopup(){
        UIView.animate(withDuration: 0.5) {
            self.popupParent.alpha = 1.0
            self.popupParent.isUserInteractionEnabled = true
            self.bodyPop.alpha = 1
            self.bodyPop.isUserInteractionEnabled = true
        }
    }
    
    func logout(completion: ()->()){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            self.success = true
        }catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            self.success = false
        }
        completion()
    }
    
    func goURl(type: Int){
        switch type{
        case 0:
            if let url = self.pp {
                UIApplication.shared.open(url)
            }
        case 1:
            if let url = self.turl {
                UIApplication.shared.open(url)
            }
        case 2:
            if let url = URL(string: "https://www.solocoin.app/app-guide/"){
                UIApplication.shared.open(url)
            }
        default:
            print("invalid choice")
        }
    }
    
    func obtainProfileInfo(completion:@escaping ()->()){
        let url = URL(string: "https://solocoin.herokuapp.com/api/v1/user/profile")!
        var request = URLRequest(url: url)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        //sepcifying header
        let authtoken = "Bearer \(UserDefaults.standard.string(forKey: "authtoken")!)"
        request.addValue(authtoken, forHTTPHeaderField: "Authorization")
        let qtask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                // Read HTTP Response Status code
                if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                    if let data = data{
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []){
                        print("j",json)
                        if let object = json as? [String:AnyObject]{
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
    
    func invite(){
        /*let text = """
        Hey! Join the #StayAtHome Challenge!
        Download the App Now!
        \(String(describing: URL(string: "https://play.google.com/store/apps/details?id=app.solocoin.solocoin")))
        """*/
        
        let item: [Any] = ["Hey! Join the #StayAtHome Challenge!","Download the App Now!","Android",URL(string: "https://play.google.com/store/apps/details?id=app.solocoin.solocoin")]
                let vc = UIActivityViewController(activityItems: item, applicationActivities: [])
                present(vc,animated: true)
    }
    @IBAction func acceptPop(_ sender: Any) {
            UIView.animate(withDuration: 0.5) {
                self.popupParent.alpha = 0
                self.popupParent.isUserInteractionEnabled = false
                self.bodyPop.alpha = 0
                self.bodyPop.isUserInteractionEnabled = false
                self.logout{
                    if self.success{
                        UserDefaults.standard.removeObject(forKey: "authtoken")
                        UserDefaults.standard.removeObject(forKey: "authVerificationID")
                        UserDefaults.standard.removeObject(forKey: "username")
                        UserDefaults.standard.removeObject(forKey: "uuid")
                        UserDefaults.standard.removeObject(forKey: "idtoken")
                        UserDefaults.standard.removeObject(forKey: "code")
                        UserDefaults.standard.removeObject(forKey: "phone")
                        UserDefaults.standard.removeObject(forKey: "name")
                        UserDefaults.standard.removeObject(forKey: "pic")
                        UserDefaults.standard.removeObject(forKey: "wallet")
                        UserDefaults.standard.removeObject(forKey: "time")
                        UserDefaults.standard.removeObject(forKey: "lat")
                        UserDefaults.standard.removeObject(forKey: "long")
                        UserDefaults.standard.removeObject(forKey: "badgeName")
                        UserDefaults.standard.removeObject(forKey: "level")
                        UserDefaults.standard.removeObject(forKey: "badgeImage")
                        UserDefaults.standard.removeObject(forKey: "offferDict")
                        publicVars.uuid = ""
                        publicVars.idtoken = ""
                        self.performSegue(withIdentifier: "fullBack", sender: nil)
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
}
