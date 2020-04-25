//
//  SCCustomButton.swift
//  solocoin
//
//  Created by indie dev on 29/03/20.
//

import UIKit

class SCCustomButton: UIButton {

    //MARK:- init Methods
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpButton()
    }
    
    //MARK:- Helper Methods
    private func setUpButton() {
        self.titleLabel?.font = SCFonts.defaultBold(size: 20.0).value
        self.backgroundColor = SCColorUtil.scRedDefaultTheme.value
        self.setTitleColor(SCColorUtil.scWhite.value, for: .normal)
        self.setRoundedCorners(withRadius: 14.0)
    }
}

