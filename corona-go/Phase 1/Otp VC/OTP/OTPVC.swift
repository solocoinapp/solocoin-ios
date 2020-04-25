//
//  OTPVC.swift
//  solocoin
//
//  Created by indie dev on 29/03/20.
//

import UIKit

class OTPVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var nextBtn: SCCustomButton!
    
    //MARK:- Constants/Variables
    private var mobileNumber: String? = nil
    
    //MARK:- init Methods
    class func createInstance() -> OTPVC {
        let cgOTPVC = OTPVC(nibName: "OTPVC", bundle: nil)
        return cgOTPVC
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            let customTFView: SCCustomTextFieldView = SCCustomTextFieldView.createInstance(imageName: "ic_mob", tfText: nil, errorText: "RECEIVE_AN_OTP".localized(), keyboardTyp: .numberPad)
            customTFView.frame = self.textFieldView.bounds
            customTFView.dataTF.addDoneButton()
            customTFView.tfText = { [weak self] text in
                guard let weakSelf = self else { return }
                weakSelf.mobileNumber = text
            }

            self.textFieldView.addSubview(customTFView)
            self.textFieldView.layoutSubviews()
        }
    }
    
    //MARK:- Helper Methods
    private func setupUI() {
        
        nextBtn.setTitle("NEXT".localized(), for: .normal)
        titleLb.text = "ENTER_MOBILE_NUMBER".localized()
        
        titleLb.font = SCFonts.defaultMedium(size: 17.0).value
        titleLb.textColor = SCColorUtil.scBlack.value
        
    }
    
    
    private func setupNavBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = .white
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: .white)
        self.title = "SIGN_UP".localized()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:SCColorUtil.scRedDefaultTheme.value]
        navController.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.hidesBackButton = true

    }
    //MARK:- Action Methods
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        self.view.hideKeyboard()
        guard let _mobileNumber = mobileNumber else { return }
        if SCViewUtils.isValidMobile(testStr: _mobileNumber) {
            let otpSuccessVC = OTPSuccessVC.createInstance(withMobNumber: _mobileNumber)
            self.navigationController?.pushViewController(otpSuccessVC, animated: true)
        }
    }
}

