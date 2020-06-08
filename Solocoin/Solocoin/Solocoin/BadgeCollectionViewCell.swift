//
//  BadgeCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/1/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    var id = 0
    var badgeImageView = UIImageView()
    var context = CIContext(options: nil)
    var levelName = UILabel()
    var level = UILabel()
    
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
    
    func blurEffect() {

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: (badgeImageView.image ?? UIImage(named:"Amazon"))!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(20, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        badgeImageView.image = processedImage
    }
    
    
}
