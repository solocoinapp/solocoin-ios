//
//  HomePage1.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/26/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class HomePage1: UIViewController {

    @IBOutlet var languageOptions: [UIButton]!

    @IBOutlet weak var dailyWeekly: UISegmentedControl!
    
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognized(gesture:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionView.layer.borderColor = UIColor.lightGray.cgColor
        questionView.layer.borderWidth = 1.0
        questionView.layer.cornerRadius = 5.0
        
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        
        questionView.addGestureRecognizer(tapGesture)
        
        let font = UIFont.systemFont(ofSize: 23)
        dailyWeekly.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

    }
    

    // Somewhere below in code put the method that is called when gesture is recognized
    @objc func gestureRecognized(gesture: UITapGestureRecognizer) {
        print("Great, it worked!")
    }
    
    @IBAction func languagePressed(_ sender: UIButton) {
        languageOptions.forEach { (button ) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
}
