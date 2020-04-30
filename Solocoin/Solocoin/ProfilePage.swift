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
    
    var profileSettings = ["Profile", "Invite", "Permissions", "Privacy Policy", "Terms & Conditions"]
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.beginUpdates()
        profileTableView.endUpdates()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = profileTableView.dequeueReusableCell(withIdentifier: "profile")
        
        cell?.textLabel?.text = profileSettings[indexPath.row]
        
        return cell!
    }

}
