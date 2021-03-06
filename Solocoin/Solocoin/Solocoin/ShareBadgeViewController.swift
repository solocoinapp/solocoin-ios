//
//  ShareBadgeViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/1/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ShareBadgeViewController: UIViewController {

    @IBOutlet weak var navBarMain: UINavigationBar!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = ""
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
        
        //UserDefaults.standard.object(forKey: "badgeImage") as? UIImage ?? UIImage(named: "Amazon")
        // Do any additional setup after loading the view.
    }

    @IBAction func shareAward(_ sender: Any) {
            /*let text = """
    I just earned \(badgeName.text) on SoloCoin app which rewards you based on your location from home, mall, store and parks. Earn real world rewards with solocoins. Challenge friends and achieve milestones and badges like me.
            
            Download the App Now!
    """*/
        let text = """
        I am saving the world by using Solocoin App to engage in social-distancing and earning rewards for it.
        Download the App and start earning exciting reward while you stay at home!
        Android:
        \(String(describing: URL(string: "https://play.google.com/store/apps/details?id=app.solocoin.solocoin")))
        AppStore:
        \(String(describing: URL(string: "https://www.solocoin.app")))
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
