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
    
    @IBAction func shareAward(_ sender: Any) {
        let text = """
I just earned \(badgeName.text) on SoloCoin app which rewards you based on your location from home, mall, store and parks. Earn real world rewards with solocoins. Challenge friends and achieve milestones and badges like me.
        
        Download the App Now!
"""
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(vc,animated: true)
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
