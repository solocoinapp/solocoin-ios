//
//  AppIconHeaderCell.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class AppIconHeaderCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.image = UIImage(named: "ic_app_logo_with_name")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

