//
//  TextField.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import Foundation
import UIKit

class SCCustomTextFieldView: UIView {

    //MARK:- IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var widthIcon: NSLayoutConstraint!
    @IBOutlet weak var dataTF: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var errorLB: UILabel!
    
    //MARK:- Constants/Variables
    var tfText: ((_ :String?)-> Void)?
    
    //MARK:- init Methods
    class func initWithNibName() -> SCCustomTextFieldView {
        let viewObj: SCCustomTextFieldView = Bundle.main.loadNibNamed("SCCustomTextFieldView", owner: self, options: nil)![0] as! SCCustomTextFieldView
        return viewObj
    }
    
    
    class func createInstance(isImageShown: Bool = true, imageName: String, tfText: String?, errorText: String?, isErrorShown: Bool = false, keyboardTyp: UIKeyboardType) -> SCCustomTextFieldView {
        let viewObj = SCCustomTextFieldView.initWithNibName()
        viewObj.setUpUIConstants(isImageShown: isImageShown, imageName: imageName, tfText: tfText, errorText: errorText, isErrorShown: isErrorShown, keyboardTyp: keyboardTyp)
        return viewObj
    }
    
    private func setUpUIConstants(isImageShown: Bool, imageName: String, tfText: String?, errorText: String?, isErrorShown: Bool, keyboardTyp: UIKeyboardType) {
        errorLB.font = SCFonts.defaultStandard(size: 12.0).value
        dataTF.font = SCFonts.defaultStandard(size: 17.0).value
        
        separatorView.backgroundColor = SCColorUtil.scRedDefaultTheme.value
        dataTF.textColor = SCColorUtil.scBlack.value
        dataTF.tintColor = SCColorUtil.scBlack.value
        
        dataTF.keyboardType = keyboardTyp
        dataTF.returnKeyType = .done
        errorLB.textColor = isErrorShown ? SCColorUtil.scRed.value : SCColorUtil.scGray.value
        widthIcon.constant = isImageShown ? 25 : 0
        
        errorLB.text = errorText
        dataTF.text = tfText
        iconImageView.image = UIImage(named: imageName)
        
    }
}

extension SCCustomTextFieldView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tfText?(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
