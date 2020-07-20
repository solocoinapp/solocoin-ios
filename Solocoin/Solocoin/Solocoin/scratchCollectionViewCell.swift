//
//  scratchCollectionViewswift
//  Solocoin
//
//  Created by Mishaal Kandapath on 7/20/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class scratchCollectionViewCell: UICollectionViewCell {
    var scratchTemp = UIImageView()
    
    func setup(){
        addSubview(scratchTemp)
        scratchTemp.translatesAutoresizingMaskIntoConstraints = false
        //scratchTemp.layer.cornerRadius = scratchTemp.frame.width/20
        scratchTemp.contentMode = .scaleToFill
        //scratchTemp.clipsToBounds  = true
        
        /*scratchTemp.layer.shadowColor = UIColor.lightGray.cgColor
        scratchTemp.layer.shadowOffset = CGSize(width:0,height: 2.0)
        scratchTemp.layer.shadowRadius = scratchTemp.frame.width/20
        scratchTemp.layer.shadowOpacity = 1.0
        scratchTemp.layer.masksToBounds = false;
        scratchTemp.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath*/
        self.contentView.layer.cornerRadius = frame.width/30
        self.layer.cornerRadius = frame.width/30
        //self.contentView.layer.borderWidth = 1.0
        //self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        scratchTemp.layer.masksToBounds = true
        scratchTemp.cornerRadius = frame.width/20
        
        scratchTemp.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        scratchTemp.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        scratchTemp.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        scratchTemp.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }
    
}
