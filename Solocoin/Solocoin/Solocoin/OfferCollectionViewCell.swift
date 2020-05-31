//
//  OfferCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/31/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    var id = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(){
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        let offerImageView = UIImageView()
        offerImageView.image = UIImage(named: "Amazon")
        offerImageView.contentMode = .scaleAspectFit
        addSubview(offerImageView)
        offerImageView.backgroundColor = .clear
        //offerImageView.layer.cornerRadius = 20
        offerImageView.contentMode = .scaleAspectFill
        offerImageView.translatesAutoresizingMaskIntoConstraints = false
        offerImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        offerImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        offerImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        offerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
