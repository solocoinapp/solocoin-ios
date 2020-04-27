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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func languagePressed(_ sender: UIButton) {
        languageOptions.forEach { (button ) in
            UIView.animate(withDuration: 0.3) {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @IBAction func cityTapped(_ sender: UIButton) {
        
    }
    
}
