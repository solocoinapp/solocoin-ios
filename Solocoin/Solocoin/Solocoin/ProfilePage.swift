//
//  ProfilePage.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import Firebase

class ProfilePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    let pp = URL(string: "https://www.solocoin.app/privacy-policy/")
    let turl = URL(string: "https://www.solocoin.app/terms-and-conditions/")
    
    var success = true
    
    //var profileSettings = ["Profile", "Rewards History", "Invite", "Permissions", "Privacy Policy", "Terms & Conditions"]
    var profileSettings = ["Invite", "Privacy Policy", "Terms & Conditions","Logout"]
//    let profileImages: [UIImage] = [#imageLiteral(resourceName: "PeopleIcon"), #imageLiteral(resourceName: "EmailIcon"), #imageLiteral(resourceName: "PermissionIcon"), #imageLiteral(resourceName: "PrivacyPolicyIcon.png"), #imageLiteral(resourceName: "TermsAndConditionsIcon")]
    
    //popup
    
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = profileTableView.dequeueReusableCell(withIdentifier: "infoCell") as? profileTableViewCell else {return UITableViewCell()}
        
        //cell?.textLabel?.text = profileSettings[indexPath.row]
        cell.labelMain.text = profileSettings[indexPath.row]
        cell.labelMain.adjustsFontSizeToFitWidth = true
        cell.selectionStyle = .none
        switch indexPath.row{
        case 0:
            cell.indximage.image = UIImage(systemName: "envelope.fill")
        case 1:
            cell.indximage.image = UIImage(systemName: "checkmark.circle.fill")
        case 2:
            cell.indximage.image = UIImage(systemName: "bookmark.fill")
        case 3:
            cell.indximage.image = UIImage(systemName: "arrowshape.turn.up.left.2.fill")
        default:
            print("nilcell")
        }
//        cell?.imageView?.image = profileImages[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            print("")
            showPopup()
        default:
            print("")
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
        default:
            print("invalid choice")
        }
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
}
