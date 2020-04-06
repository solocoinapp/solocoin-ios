//
//  SCNavigationBarUtil.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import Foundation
import UIKit

class SCNavigationBarUtil: NSObject {
    
    class func customiseUiNavigationBarTransparent(_ navigationController: UINavigationController, color: UIColor) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false;
        navigationController.navigationBar.barTintColor = color
    }
    
    class func getRedBackButtonInstance() -> UIButton {
        let backBtn = UIButton(type: UIButton.ButtonType.custom)
        let templateImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(templateImage, for: UIControl.State())
        backBtn.setTitle("", for: UIControl.State())
        backBtn.tintColor = SCColorUtil.scRedDefaultTheme.value
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -30, bottom: 0, right: 0)
        backBtn.titleLabel?.font = SCFonts.defaultStandard(size: 16.0).value
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
        return backBtn
    }
    
    class func getBackButtonInstance(withTitle titleString: String, titleColor: UIColor) -> UIButton {
        let backBtn = UIButton(type: UIButton.ButtonType.custom)
        let backBtnImage = UIImage(named: "ic_back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(backBtnImage, for: UIControl.State())
        backBtn.setTitle(titleString, for: UIControl.State())
        backBtn.setTitleColor(titleColor, for: UIControl.State())
        backBtn.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        backBtn.titleLabel?.minimumScaleFactor = 0.5
        backBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        backBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -16, bottom: 0, right: 0)
        backBtn.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        return backBtn
    }
    
    class func getRightButtonInstance(withTitle titleString: String, titleColor: UIColor) -> UIButton {
        let doneBtn = UIButton(type: UIButton.ButtonType.custom)
        doneBtn.setTitle(titleString, for: UIControl.State())
        doneBtn.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        doneBtn.setTitleColor(titleColor, for: UIControl.State())
        doneBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 30)
        return doneBtn
    }
    
    class func getCancelBtnInstance(withTitle titleString: String, titleColor: UIColor) -> UIButton {
        let cancelBtn = UIButton(type: UIButton.ButtonType.custom)
        cancelBtn.setTitle(titleString, for: UIControl.State())
        cancelBtn.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
        cancelBtn.setTitleColor(titleColor, for: UIControl.State())
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        return cancelBtn
    }
    
}
