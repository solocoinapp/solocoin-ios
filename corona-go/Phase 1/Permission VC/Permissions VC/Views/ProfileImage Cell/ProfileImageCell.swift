//
//  ProfileImageCell.swift
//  corona-go
//
//  Created by indie dev on 02/04/20.
//

import UIKit

class ProfileImageCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var cameraIView: UIImageView!
    
    //MARK:- init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpConstant() {
        cameraIView.setRoundedCorners()
        cameraIView.image = UIImage(named: "ic_camera_permission")
    }

}
