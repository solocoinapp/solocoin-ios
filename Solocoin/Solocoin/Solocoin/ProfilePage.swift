//
//  ProfilePage.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/30/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ProfilePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var profileSettings = ["Profile", "Rewards History", "Invite", "Permissions", "Privacy Policy", "Terms & Conditions"]
    
//    let profileImages: [UIImage] = [#imageLiteral(resourceName: "PeopleIcon"), #imageLiteral(resourceName: "EmailIcon"), #imageLiteral(resourceName: "PermissionIcon"), #imageLiteral(resourceName: "PrivacyPolicyIcon.png"), #imageLiteral(resourceName: "TermsAndConditionsIcon")]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profile")
        
        cell?.textLabel?.text = profileSettings[indexPath.row]
//        cell?.imageView?.image = profileImages[indexPath.row]
        return cell!
    }

}
