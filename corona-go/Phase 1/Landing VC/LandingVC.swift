//
//  LandingVC.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import UIKit

class LandingVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var landingImageView: UIImageView!
    @IBOutlet weak var landingTxt: UILabel!
    @IBOutlet weak var pageContrl: UIPageControl!
    @IBOutlet weak var nextBtn: SCCustomButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    //MARK:- Constants/Variables
    private var swipeCount: Int = 0
    private var canNavigate: Bool = false
    fileprivate enum SwipeDirection {
        case left
        case right
    }
    
    //MARK:- init Methods
    class func createInstance() -> LandingVC {
        let cgLandingVC = LandingVC(nibName: "LandingVC", bundle: nil)
        return cgLandingVC
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        swipeGesture()
        changeUIOnSwipe(forSwipeInt: swipeCount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Helper Methods
    private func setupUI() {
        appIcon.image = UIImage(named: "ic_app_logo_with_name")
        skipBtn.setTitle("SKIP".localized(), for: .normal)
        skipBtn.setTitleColor(SCColorUtil.scGray.value, for: .normal)
        landingTxt.font = SCFonts.defaultBold(size: 16.0).value
        skipBtn.titleLabel?.font = SCFonts.defaultStandard(size: 17.0).value
    }
    
    
    ///Swipe Gesture
      private func swipeGesture()
       {
           // Adding Swipe Gesture---
           let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeRight.delegate = self
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
           self.view.addGestureRecognizer(swipeRight)
           
           let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
           swipeLeft.delegate = self
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
           self.view.addGestureRecognizer(swipeLeft)
       }
       
       @objc private func respondToSwipeGesture(gesture: UIGestureRecognizer) {
           if let swipeGesture = gesture as? UISwipeGestureRecognizer {
               switch swipeGesture.direction {
               case UISwipeGestureRecognizer.Direction.right:
                swipeScreen(swipeDirection: .left)
                   break
               case UISwipeGestureRecognizer.Direction.left:
                swipeScreen(swipeDirection: .right)
                   break
               default:
                   break
               }
           }
       }
       ////Swip Gesture Delegate
       func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
    
    private func swipeScreen(swipeDirection direction: SwipeDirection) {
        switch direction {
        case .left:
            swipeCount = swipeCount - 1
            if swipeCount == -1 {
                swipeCount = 0
            }
            changeUIOnSwipe(forSwipeInt: swipeCount)
            break
        case .right:
            swipeCount = swipeCount + 1
            if swipeCount == 3 {
                swipeCount = 2
            }
            changeUIOnSwipe(forSwipeInt: swipeCount)
            break
        
        }
    }
    
    private func changeUIOnSwipe(forSwipeInt swipeCount: Int) {
        canNavigate = false
        pageContrl.currentPage = swipeCount
        switch swipeCount {
        case 0:
            landingImageView.image = UIImage(named: "ic_landing_1")
            landingTxt.text = "PRACTISE_SOCIAL_DISTANCING".localized()
            nextBtn.setTitle("GET_STARTED".localized(), for: .normal)
            break
        case 1:
            landingImageView.image = UIImage(named: "ic_landing_2")
            landingTxt.text = "EARN_REAL_WORLD_REWARDS".localized()
            nextBtn.setTitle("NEXT".localized(), for: .normal)
            break
        case 2:
            landingImageView.image = UIImage(named: "ic_landing_3")
            landingTxt.text = "STAY_SAFE".localized()
            nextBtn.setTitle("CREATE_ACCOUNT".localized(), for: .normal)
            canNavigate = true
            break
        default:
            break
        }
    }
    
    //MARK:- Action Methods
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        if canNavigate {
            navigateToOTPScreen()
        }
        swipeScreen(swipeDirection: .right)
    }
    
    @IBAction func skipBtnTapped(_ sender: UIButton) {
        navigateToOTPScreen()
    }
    
    private func navigateToOTPScreen() {
        let otpVc = OTPVC.createInstance()
        self.navigationController?.pushViewController(otpVc, animated: true)
    }
}

