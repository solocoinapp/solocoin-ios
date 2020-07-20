//
//  PlaceHolderScratchCardCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 7/19/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class PlaceHolderScratchCardCollectionViewCell: UICollectionViewCell {
    
    var trophy = UIImageView()
    var mainLabel = UILabel()
    
    func setup(){
        self.contentView.layer.cornerRadius = frame.width/30
        self.layer.cornerRadius = frame.width/30
        self.layer.masksToBounds = true
        backgroundColor = .white//.init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        trophy.image = UIImage(named: "trophyIcon")!
        mainLabel.text = "No New Scratch Cards Available"
        addSubview(trophy)
        trophy.isHidden = true
        addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        trophy.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.textColor = UIColor.init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
        mainLabel.font = UIFont(name: "Poppins-SemiBold", size: 15)
        
        trophy.setImageColor(color: .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1))
        /*trophy.image?.withTintColor(.init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1), renderingMode: UIImage.RenderingMode(rawValue: 0)!)
        trophy.tintColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)//trophy.image?.withTintColor(init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1), renderingMode: .)//trophy.image?.withTintColor(.init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1))*/
        
        trophy.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        trophy.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        trophy.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        trophy.widthAnchor.constraint(equalToConstant: frame.width/4).isActive = true
        trophy.contentMode = .scaleAspectFit
        
        mainLabel.numberOfLines = 1
        mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
        mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        mainLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        mainLabel.adjustsFontSizeToFitWidth = true
        mainLabel.textAlignment = .center
        
    }
    
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
