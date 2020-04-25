//
//  OTPSuccessVC.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class OTPSuccessVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var mobIcon: UIImageView!
    @IBOutlet weak var mobNumberLb: UILabel!
    @IBOutlet weak var mobSeparatorView: UIView!
    @IBOutlet weak var otpTf: UITextField!
    @IBOutlet weak var otpSeparatorView: UIView!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var nextBtn: SCCustomButton!
    @IBOutlet weak var supportingTxt: UILabel!
    @IBOutlet weak var termsBtn: UIButton!
    @IBOutlet weak var termsSeparatorView: UIView!
    @IBOutlet weak var andLb: UILabel!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var privacySeparatorView: UIView!
    
    //MARK:- Constants/Variables
    private var mobileNumber: String!
    private var otpCode: String? = nil
    
    //MARK:- init Methods
    class func createInstance(withMobNumber number: String) -> OTPSuccessVC {
        let cgOTPSuccessVC = OTPSuccessVC(nibName: "OTPSuccessVC", bundle: nil)
        cgOTPSuccessVC.mobileNumber = number
        return cgOTPSuccessVC
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
    }
    
    //MARK:- Helper Methods
    private func setupUI() {
        mobNumberLb.text = mobileNumber
        mobIcon.image = UIImage(named: "ic_mob")
        setUpTexts()
        setUpColorConst()
        setupFonts()
        otpTf.addDoneButton()
        otpTf.keyboardType = .numberPad
    }
    
    private func setUpTexts() {
        titleLb.text = "OTP_SUCCESS".localized()
        resendOtpBtn.setTitle("RESEND_OTP".localized(), for: .normal)
        nextBtn.setTitle("CREATE_ACCOUNT".localized(), for: .normal)
        supportingTxt.text = "GUIDE_TEXT".localized()
        termsBtn.setTitle("", for: .normal)
        andLb.text = "TERMS_OF_SERVICE".localized() + " " + "AND".localized() + " " + "PRIVACY_POLICY".localized()
        privacyBtn.setTitle("", for: .normal)
    }
    
    private func setUpColorConst() {
        titleLb.textColor = SCColorUtil.scBlack.value
        mobNumberLb.textColor = SCColorUtil.scBlack.value
        mobSeparatorView.backgroundColor = SCColorUtil.scRedDefaultTheme.value
        otpTf.textColor = SCColorUtil.scBlack.value
        otpTf.tintColor = SCColorUtil.scBlack.value
        otpSeparatorView.backgroundColor = SCColorUtil.scRedDefaultTheme.value
        resendOtpBtn.setTitleColor(SCColorUtil.scGray.value, for: .normal)
        supportingTxt.textColor = SCColorUtil.scGray.value
        termsBtn.setTitleColor(SCColorUtil.scGray.value, for: .normal)
        termsSeparatorView.backgroundColor = SCColorUtil.scGray.value
        andLb.textColor = SCColorUtil.scGray.value
        privacyBtn.setTitleColor(SCColorUtil.scGray.value, for: .normal)
        privacySeparatorView.backgroundColor = SCColorUtil.scGray.value
    }
    
    private func setupFonts() {
        titleLb.font = SCFonts.defaultMedium(size: 17.0).value
        mobNumberLb.font = SCFonts.defaultStandard(size: 17.0).value
        otpTf.font = SCFonts.defaultStandard(size: 17.0).value
        resendOtpBtn.titleLabel?.font = SCFonts.defaultStandard(size: 12.0).value
        supportingTxt.font = SCFonts.defaultStandard(size: 12.0).value
        termsBtn.titleLabel?.font = SCFonts.defaultStandard(size: 12.0).value
        andLb.font = SCFonts.defaultStandard(size: 12.0).value
        privacyBtn.titleLabel?.font = SCFonts.defaultStandard(size: 12.0).value
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
        let signupVC = SignUpVC.createInstance()
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func resendOtpBtnTapped(_ sender: UIButton) {
        self.view.hideKeyboard()
        
    }
    
    @IBAction func termsBtnTapped(_ sender: UIButton) {
        self.view.hideKeyboard()
        openTnCandPrivacyVC(forType: .tnC)
    }
    
    @IBAction func privacyBtnTapped(_ sender: UIButton) {
        self.view.hideKeyboard()
        openTnCandPrivacyVC(forType: .privacy)
    }
    
    private func  openTnCandPrivacyVC(forType type: URLType) {
        let vc = OpenUrlWithWKWebViewVC.createInstance(forType: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

