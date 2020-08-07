//
//  ScoreCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/22/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ScoreCollectionViewCell: UICollectionViewCell {
    
    var rankLabel = UILabel()
    var nameLabel = UILabel()
    var countryLabel = UILabel()
    var countryImage = UIImageView()
    var coinsLabel = UILabel()
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           configureCell()
       }
       
   required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
   }
       
   func configureCell(){
    backgroundColor = .init(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
    self.contentView.layer.cornerRadius = frame.width/30
    self.layer.cornerRadius = frame.width/30
    self.contentView.layer.borderWidth = 1.0
    self.contentView.layer.borderColor = UIColor.clear.cgColor
    self.contentView.layer.masksToBounds = true
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    self.layer.shadowRadius = 2.0
    self.layer.shadowOpacity = 0.5
    self.layer.masksToBounds = false
    rankLabel.adjustsFontSizeToFitWidth = true
    nameLabel.adjustsFontSizeToFitWidth = true
    countryImage.contentMode = .scaleAspectFit
    addSubview(rankLabel)
    addSubview(nameLabel)
    addSubview(countryImage)
    addSubview(countryLabel)
    addSubview(coinsLabel)
    rankLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
    rankLabel.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
    nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
    nameLabel.textColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
    countryLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
    countryLabel.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
    coinsLabel.font = UIFont(name: "Poppins-SemiBold", size: 18)
    coinsLabel.textColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
    rankLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    countryImage.translatesAutoresizingMaskIntoConstraints = false
    countryLabel.translatesAutoresizingMaskIntoConstraints = false
    coinsLabel.translatesAutoresizingMaskIntoConstraints = false
    rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
    rankLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
    rankLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    rankLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/12).isActive = true
    nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
    nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    nameLabel.leftAnchor.constraint(equalTo: rankLabel.rightAnchor, constant: 10).isActive = true
    nameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/2.5).isActive = true
    countryImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
    countryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
    countryImage.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 20).isActive = true
    countryImage.widthAnchor.constraint(equalToConstant: contentView.frame.width/12).isActive = true
    countryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
    countryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    countryLabel.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 8).isActive = true
    countryLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/12).isActive = true
    coinsLabel.leftAnchor.constraint(equalTo: countryLabel.rightAnchor, constant: 0).isActive = true
    coinsLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
    coinsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:8).isActive = true
    coinsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
   }
}
