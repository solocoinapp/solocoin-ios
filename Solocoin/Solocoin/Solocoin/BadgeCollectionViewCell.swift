///
//  BadgeCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/1/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit
import SDWebImage

class BadgeCollectionViewCell: UICollectionViewCell {
    var id = 0
    var clickEnabled = true
    var badgeImageView = UIImageView()
    var context = CIContext(options: nil)
    var levelName = UILabel()
    var level = UILabel()
    let levelNames = [["Alpha Warrior",1000],["Beta Warrior",2500],["Omega Warrior",5000],["Chief Warrior",10000],["Ultimate Warrior",25000],["Supreme Warrior",50000],["Master",100000],["Grand Master",250000],["Ultimate Master",500000],["Supreme Master",1000000],["Universe God",5000000],["Mutliverse God",2500000]]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(){
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        levelName.text = "Name"
        level.text = "level"
        levelName.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        level.font = UIFont(name:"HelveticaNeue-Bold", size: 12.0)
        level.backgroundColor = UIColor.init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
        levelName.backgroundColor = UIColor.init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
        //levelName.font = UIFont(name: "OpenSans-Bold", size: 20)
        level.textAlignment = .center
        levelName.textAlignment = .center
        levelName.adjustsFontSizeToFitWidth = true
        levelName.adjustsFontSizeToFitWidth = true
        addSubview(levelName)
        addSubview(level)
        level.textColor = UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        levelName.textColor = UIColor.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        //constrainst for label level
        level.translatesAutoresizingMaskIntoConstraints = false
        //level.topAnchor.constraint(equalTo: topAnchor).isActive = true
        level.heightAnchor.constraint(equalToConstant: frame.height/12).isActive = true
        level.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        level.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        level.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //constrainst for label levelname
        levelName.translatesAutoresizingMaskIntoConstraints = false
        //level.topAnchor.constraint(equalTo: topAnchor).isActive = true
        levelName.heightAnchor.constraint(equalToConstant: frame.height/5).isActive = true
        levelName.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        levelName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        levelName.bottomAnchor.constraint(equalTo: level.topAnchor).isActive = true
    
        badgeImageView.image = UIImage(named: "Amazon")
        badgeImageView.contentMode = .scaleAspectFill
        badgeImageView.clipsToBounds = true
        addSubview(badgeImageView)
        badgeImageView.backgroundColor = .init(red: 239/255, green: 238/255, blue: 241/255, alpha: 1)
        //badgeImageView.layer.cornerRadius = 20
        badgeImageView.contentMode = .scaleAspectFill
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        badgeImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        badgeImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
       badgeImageView.bottomAnchor.constraint(equalTo: levelName.topAnchor).isActive = true
    }
    
    func blurEffect(status: Bool) {
        if status{
            let currentFilter = CIFilter(name: "CIGaussianBlur")
            let beginImage = CIImage(image: (badgeImageView.image ?? UIImage(named:"AppIcon"))!)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(20, forKey: kCIInputRadiusKey)

            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            badgeImageView.image = processedImage
        }else{
            let currentFilter = CIFilter(name: "CIGaussianBlur")
            let beginImage = CIImage(image: (badgeImageView.image ?? UIImage(named:"Amazon"))!)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(0, forKey: kCIInputRadiusKey)

            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            badgeImageView.image = processedImage
        }
    }
    
    func putinfo(){
        UserDefaults.standard.set(self.levelNames[(self.level.text! as! Int)-2][0], forKey: "badgeName")
        UserDefaults.standard.set(self.level.text!, forKey: "level")
        UserDefaults.standard.set(self.badgeImageView.image, forKey: "badgeImage")
    }
    
    
}
