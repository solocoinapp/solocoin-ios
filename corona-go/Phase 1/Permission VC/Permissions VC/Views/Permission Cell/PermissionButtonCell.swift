//
//  PermissionButtonCell.swift
//  corona-go
//
//  Created by indie dev on 02/04/20.
//

import UIKit

class PermissionButtonCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var checkedIcon: UIImageView!
    @IBOutlet weak var permissionBtn: UIButton!
    
    //MARK:- Constants/Variables
    var permissionBtnTapped: (() -> Void)?
    
    //MARK:- init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpConstant()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setUpConstant() {
        permissionBtn.setRoundedCorners(withRadius: 14.0)
        permissionBtn.layer.borderColor = SCColorUtil.scBrown.cgValue
        permissionBtn.layer.borderWidth = 1.0
        permissionBtn.titleLabel?.font = SCFonts.defaultBold(size: 20.0).value
    }
    
    func configureCell(withBtnTitle title: String) {
        permissionBtn.setTitle(title, for: .normal)
    }
    
    func defaultBtnUISetup() {
        checkedIcon.isHidden = true
        permissionBtn.backgroundColor = SCColorUtil.scWhite.value
        permissionBtn.setTitleColor(SCColorUtil.scBrown.value, for: .normal)
    }
    
    func changeUIConstant() {
        permissionBtn.backgroundColor = SCColorUtil.scBrown.value
        permissionBtn.setTitleColor(SCColorUtil.scWhite.value, for: .normal)
        checkedIcon.isHidden = false
        checkedIcon.image = UIImage(named: "ic_check")
    }
    
    //MARK:- Action Methods
    @IBAction func permissionBtnTapped(_ sender: UIButton) {
        permissionBtnTapped?()
    }
    
}
