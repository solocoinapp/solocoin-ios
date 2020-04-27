//
//  OTP2Controller.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OTP2Controller: UIViewController {
 
    //VARIABLES
    var mobile = ""
    // OUTLETS
    @IBOutlet weak var mobileNumber: UITextField!

    @IBOutlet weak var OTP: UITextField!
    //OTP.textContentType = .oneTimeCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Next(_ sender: Any) {
        mobileNumber.text! = mobile
    }

}
