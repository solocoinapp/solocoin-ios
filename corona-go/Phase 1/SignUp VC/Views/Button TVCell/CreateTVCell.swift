//
//  CreateTVCell.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class CreateTVCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var createAccountBtn: SCCustomButton!
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var googlePlusBtn: UIButton!
    @IBOutlet weak var skipNowBtn: UIButton!
    
    //MARK:- Constants/Variables
    var createAccountBtnTapped: (() -> Void)?
    var faceBookBtnTapped: (() -> Void)?
    var googlePlusBtnTapped: (() -> Void)?
    var skipNowBtnTapped: (() -> Void)?
    
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

        skipNowBtn.titleLabel?.font = SCFonts.defaultStandard(size: 12.0).value
        skipNowBtn.setTitleColor(SCColorUtil.scGray.value, for: .normal)
        
        faceBookBtn.layer.borderColor = SCColorUtil.scRedDefaultTheme.cgValue
        googlePlusBtn.layer.borderColor = SCColorUtil.scRedDefaultTheme.cgValue
        faceBookBtn.layer.borderWidth = 1.0
        googlePlusBtn.layer.borderWidth = 1.0
        faceBookBtn.setRoundedCorners()
        googlePlusBtn.setRoundedCorners()
        
        faceBookBtn.setImage(UIImage(named: "ic_fb_logo"), for: .normal)
        googlePlusBtn.setImage(UIImage(named: "ic_gPlus_logo"), for: .normal)
    }
    
    func configureCell(withBtnTitle title: String, skipTitle: String) {
        createAccountBtn.setTitle(title, for: .normal)
        skipNowBtn.setTitle(skipTitle, for: .normal)
    }
    
    //MARK:- Action Methods
    @IBAction func createAccountTapped(_ sender: UIButton) {
        self.hideKeyboard()
        createAccountBtnTapped?()
    }
    
    @IBAction func faceBookTapped(_ sender: UIButton) {
        self.hideKeyboard()
        faceBookBtnTapped?()
    }
    
    @IBAction func googlePlusTapped(_ sender: UIButton) {
        self.hideKeyboard()
        googlePlusBtnTapped?()
    }
    
    @IBAction func skipNowTapped(_ sender: UIButton) {
        self.hideKeyboard()
        skipNowBtnTapped?()
    }
}

