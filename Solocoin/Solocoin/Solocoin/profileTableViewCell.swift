//
//  profileTableViewCell.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/12/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class profileTableViewCell: UITableViewCell {
    @IBOutlet weak var indximage: UIImageView!
    @IBOutlet weak var labelMain: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
