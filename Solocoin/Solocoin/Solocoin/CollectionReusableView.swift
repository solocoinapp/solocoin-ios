//
//  CollectionReusableView.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/10/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class CollectionReusableViewHeader: UICollectionReusableView {
    /*static var reuseIdentifier1: String {
      return String(describing: CollectionReusableViewHeader.self)
    }*/
    static let identifier = "headerIdentifier"
    @IBOutlet weak var awardsUnlocked: UILabel!
    @IBOutlet weak var circle3: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var coinsLeft: UILabel!
    @IBOutlet weak var bigCoinsLeft: UILabel!
    @IBOutlet weak var badgesUnlockedNo: UILabel!
    @IBOutlet weak var crnLevel: UILabel!
    @IBOutlet weak var Level3: UILabel!
    @IBOutlet weak var Level2: UILabel!
    @IBOutlet weak var Level1: UILabel!
    @IBOutlet weak var levelProgress: UIProgressView!
    @IBOutlet weak var scoreView: UIView!
    //@IBOutlet weak var leaderBoardHeader: UILabel!
    @IBOutlet weak var leaderBoardSec: UIImageView!
    /*@IBOutlet weak var filledProgressBar: UIImageView!
    var emptyProgress = UIImageView(image: UIImage(named: "emptyProgress")!)*/
    
    /*func moveProgress(currentLevel: Int, currentCoins: Int, nextCoins: Int,diff: Int){
        if currentLevel%3==0 && Float(diff-(nextCoins-currentCoins)) == Float(diff)/2.0{
            self.emptyProgress.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }else if currentLevel%3==0{
            let to_hide = (3*Float(self.filledProgressBar.frame.width)/4.0) + Float((nextCoins-currentCoins))/Float(diff)/4.0
            self.emptyProgress.frame = CGRect(x: 0, y: 0, width: CGFloat(to_hide), height: self.filledProgressBar.frame.height)
        }else if currentLevel%3==2{
            let to_show = (self.filledProgressBar.frame.width)/2.0 + Float(diff-(nextCoins-currentCoins))/4
        }
    }*/
    
}
