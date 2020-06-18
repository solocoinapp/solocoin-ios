//
//  SolocoinAlert.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/15/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class SolocoinAlert: UIView{
    
    static let instance = SolocoinAlert()
    private var success = false
    
    @IBOutlet weak var AlertView: UIView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var mainMessage: UILabel!
    @IBOutlet weak var acceptBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)
        configureAlert()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAlert(){
        acceptBtn.layer.cornerRadius = acceptBtn.frame.width/25
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
    
    enum choice{
        case normal
    }
    
    func showAlert(top: String,main: String,btnText: String, alertType: choice){
        topMessage.text = top
        acceptBtn.titleLabel?.text = btnText
        mainMessage.text = main
        UIApplication.shared.windows.first?.addSubview(parentView)
    }
    @IBAction func accepted(_ sender: Any) {
        publicVars.accepted = true
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
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
            print("wooo")
            ProfilePage().performSegue(withIdentifier: "fullBack", sender: nil)
            //self.performSegue(withIdentifier: "fullBack", sender: nil)
        }catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        parentView.removeFromSuperview()
    }
    @IBAction func cancelled(_ sender: Any) {
        //publicVars.cancelled = true
        parentView.removeFromSuperview()
    }
}
