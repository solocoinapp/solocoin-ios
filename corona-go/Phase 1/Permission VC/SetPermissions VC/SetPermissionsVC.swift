//
//  SetPermissionsVC.swift
//  corona-go
//
//  Created by indie dev on 31/03/20.
//

import UIKit

class SetPermissionsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var landingImageView: UIImageView!
    @IBOutlet weak var landingTxt: UILabel!
    @IBOutlet weak var nextBtn: SCCustomButton!
    
    //MARK:- init Methods
    class func createInstance() -> SetPermissionsVC {
        let cgSetPermissionsVC = SetPermissionsVC(nibName: "SetPermissionsVC", bundle: nil)
        return cgSetPermissionsVC
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    
    //MARK:- Helper Methods
    private func setupUI() {
        appIcon.image = UIImage(named: "ic_app_logo")
        landingImageView.image = UIImage(named: "ic_permissions")
        landingTxt.font = SCFonts.defaultMedium(size: 35.0).value
        landingTxt.text = "APP_NAME".localized()
        nextBtn.setTitle("SET_PERMISSIONS".localized(), for: .normal)
    }
    
    
    private func setupNavBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = .white
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: .white)
        let textAttributes = [NSAttributedString.Key.foregroundColor:SCColorUtil.scRedDefaultTheme.value]
        navController.navigationBar.titleTextAttributes = textAttributes
        
        self.title = "WELCOME".localized()
        self.navigationItem.hidesBackButton = false
        let backBtn = SCNavigationBarUtil.getRedBackButtonInstance()
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    //MARK:- Action Methods
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        let vc = PermissionsVC.createInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func backBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
