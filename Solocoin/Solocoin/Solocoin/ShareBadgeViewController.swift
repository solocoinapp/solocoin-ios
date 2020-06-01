//
//  ShareBadgeViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/1/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ShareBadgeViewController: UIViewController {

    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        level.text = UserDefaults.standard.string(forKey: "level")
        badgeName.text = UserDefaults.standard.string(forKey: "badgeName")
        badgeImage.image = UIImage(named: UserDefaults.standard.string(forKey: "badgeImage") ?? "Amazon")
        // Do any additional setup after loading the view.
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
