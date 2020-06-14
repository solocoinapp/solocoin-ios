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
    //@IBOutlet weak var leaderBoardHeader: UILabel!
    @IBOutlet weak var leaderBoardSec: UIImageView!

}
