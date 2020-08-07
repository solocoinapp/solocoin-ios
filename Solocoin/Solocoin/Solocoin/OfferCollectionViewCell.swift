//
//  OfferCollectionViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 5/31/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    var id = "0"
    var offerImageView = UIImageView()
    var altText = UILabel()
    var cashText = UILabel()
    var coinsText = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(){
        self.contentView.layer.cornerRadius = frame.width/17
        self.layer.cornerRadius = frame.width/17
        //self.contentView.layer.borderWidth = 1.0
        //self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        //self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    func addImage(comp: UIImage){
        //let offerImageView = UIImageView()
        /*altText.removeFromSuperview()
        cashText.removeFromSuperview()
        coinsText.removeFromSuperview()*/
        offerImageView.image = comp//UIImage(named: "Amazon")
        offerImageView.contentMode = .scaleAspectFit
        offerImageView.clipsToBounds = true
        addSubview(offerImageView)
        offerImageView.backgroundColor = .clear
        offerImageView.contentMode = .scaleAspectFit
        offerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        altText.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        altText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        altText.textAlignment = .center
        addSubview(altText)
        backgroundColor = .white
        altText.translatesAutoresizingMaskIntoConstraints = false
        
        //cash Text
        cashText.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
        cashText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(cashText)
        cashText.textAlignment = .center
        cashText.translatesAutoresizingMaskIntoConstraints = false
        
        //coinsText
        coinsText.font = UIFont(name:"HelveticaNeue-Bold", size: 8.0)
        coinsText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(coinsText)
        coinsText.textAlignment = .center
        coinsText.translatesAutoresizingMaskIntoConstraints = false
        
        
        altText.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        altText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        altText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        altText.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
        //offerImageView.layer.cornerRadius = 20
        
        offerImageView.topAnchor.constraint(equalTo: altText.bottomAnchor).isActive = true
        offerImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        offerImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //offerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        offerImageView.heightAnchor.constraint(equalToConstant: frame.height/2.5).isActive = true
        
        cashText.topAnchor.constraint(equalTo: offerImageView.bottomAnchor).isActive = true
        cashText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cashText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cashText.heightAnchor.constraint(equalToConstant: frame.height/6).isActive = true
        
       
        coinsText.topAnchor.constraint(equalTo: cashText.bottomAnchor).isActive = true
        coinsText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        coinsText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        coinsText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        //coinsText.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    func removeImage(){
        self.offerImageView.removeFromSuperview()
        //altText.contentMode = .scaleAspectFill
        //topText
        altText.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        altText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        altText.textAlignment = .center
        addSubview(altText)
        backgroundColor = .white
        altText.translatesAutoresizingMaskIntoConstraints = false
        altText.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        altText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        altText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        altText.heightAnchor.constraint(equalToConstant: frame.height/3).isActive = true
        
        //cash Text
        cashText.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        cashText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(cashText)
        cashText.textAlignment = .center
        cashText.translatesAutoresizingMaskIntoConstraints = false
        cashText.topAnchor.constraint(equalTo: altText.bottomAnchor).isActive = true
        cashText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cashText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cashText.heightAnchor.constraint(equalToConstant: frame.height/3).isActive = true
        
        //coinsText
        coinsText.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        coinsText.textColor = .init(red: 16/255, green: 32/255, blue: 90/255, alpha: 1)
        addSubview(coinsText)
        coinsText.textAlignment = .center
        coinsText.translatesAutoresizingMaskIntoConstraints = false
        coinsText.topAnchor.constraint(equalTo: cashText.bottomAnchor).isActive = true
        coinsText.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        coinsText.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        coinsText.bottomAnchor.constraint(equalTo: bottomAnchor)
    }
}
