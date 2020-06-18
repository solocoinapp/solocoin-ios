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
        badgeName.adjustsFontSizeToFitWidth = true
        //print(UserDefaults.standard.string(forKey: "badgeName") ?? "lll")
        //badgeImage.image = UIImage(named: UserDefaults.standard.string(forKey: "badgeImage") ?? "defaultBadge")
        let url = UserDefaults.standard.string(forKey: "badgeImage") ?? "defaultBadge"
        switch url{
        case "defaultBadge":
            badgeImage.image = UIImage(named: UserDefaults.standard.string(forKey: "badgeImage") ?? "defaultBadge")
        default:
            
            badgeImage.sd_setImage(with: URL(string: (url as! String))) { (image, error, cache, urlGiven) in
                if error == nil{
                    print("sharing")
                }else{
                    print("sharin",error?.localizedDescription)
                }
            }
        }
    }

    @IBAction func shareAward(_ sender: Any) {
            let text = """
    I just earned \(badgeName.text) on SoloCoin which rewards you based on your location from home, mall, store and parks. Earn real world rewards with solocoins. Challenge friends and achieve milestones and badges like me.
            
            Download the App Now!
    """
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
            present(vc,animated: true)
        }

}
