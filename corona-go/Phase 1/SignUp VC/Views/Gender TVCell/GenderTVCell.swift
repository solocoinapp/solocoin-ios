//
//  GenderTVCell.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class GenderTVCell: UITableViewCell {
    //MARK:- IBOutlets
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var feMaleBtn: UIButton!
    
    //MARK:- Constants/Variables
    var genderBtnTapped: ((_ : String) -> Void)?
    
    //MARK:- init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(withGender text: String?) {
        guard let _text = text, !_text.isEmpty else {
            setUpConstants()
            return
        }
        
        if _text.lowercased() == "male" {
            changeBtnUI(isMaleSelected: true, isFemaleSelected: false)
        }else{
            changeBtnUI(isMaleSelected: false, isFemaleSelected: true)
        }
    }
    
    private func setUpConstants() {
        maleBtn.backgroundColor = SCColorUtil.scWhite.value
        maleBtn.titleLabel?.font = SCFonts.defaultBold(size: 20).value
        maleBtn.setTitle("MALE".localized(), for: .normal)
        maleBtn.setTitleColor(SCColorUtil.scBrown.value, for: .normal)
        maleBtn.layer.borderColor = SCColorUtil.scBrown.cgValue
        maleBtn.layer.borderWidth = 0.5
        maleBtn.setRoundedCorners(withRadius: 14.0)
        
        feMaleBtn.backgroundColor = SCColorUtil.scWhite.value
        feMaleBtn.titleLabel?.font = SCFonts.defaultBold(size: 20).value
        feMaleBtn.setTitle("FEMALE".localized(), for: .normal)
        feMaleBtn.setTitleColor(SCColorUtil.scBrown.value, for: .normal)
        feMaleBtn.layer.borderColor = SCColorUtil.scBrown.cgValue
        feMaleBtn.layer.borderWidth = 0.5
        feMaleBtn.setRoundedCorners(withRadius: 14.0)
    }
    
    private func changeBtnUI(isMaleSelected: Bool, isFemaleSelected: Bool) {
        setUpConstants()
        if isMaleSelected {
            maleBtnSelected()
        }
        if isFemaleSelected {
            feMaleBtnSelected()
        }
    }
    
    private func maleBtnSelected() {
        maleBtn.backgroundColor = SCColorUtil.scBrown.value
        maleBtn.setTitleColor(SCColorUtil.scWhite.value, for: .normal)
    }
    
    private func feMaleBtnSelected() {
        feMaleBtn.backgroundColor = SCColorUtil.scBrown.value
        feMaleBtn.setTitleColor(SCColorUtil.scWhite.value, for: .normal)
    }
    
    //MARK:- Action Methods
    @IBAction func maleBtnTapped(_ sender: UIButton) {
        changeBtnUI(isMaleSelected: true, isFemaleSelected: false)
        genderBtnTapped?("MALE")
    }
    
    @IBAction func femaleBtnTapped(_ sender: UIButton) {
        changeBtnUI(isMaleSelected: false, isFemaleSelected: true)
        genderBtnTapped?("FEMALE")
    }
}
