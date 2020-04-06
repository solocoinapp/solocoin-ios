//
//  DOBTVCell.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class DOBTVCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dobBTN: UIButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLB: UILabel!
    
    //MARK:- Constants/Variables
    var dobBTNTapped: (() -> Void)?
    
    //MARK:- init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpConstants()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpConstants() {
        iconImageView.image = UIImage(named: "ic_dob")
        dobBTN.setTitleColor(SCColorUtil.scBlack.value, for: .normal)
        dobBTN.titleLabel?.font = SCFonts.defaultStandard(size: 17.0).value
        
        separatorView.backgroundColor = SCColorUtil.scRedDefaultTheme.value
    }
    
    //MARK:- Action Methods
    @IBAction func dobBtnTapped(_ sender: UIButton) {
        dobBTNTapped?()
    }
}
