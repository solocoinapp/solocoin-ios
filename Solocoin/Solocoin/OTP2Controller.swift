//
//  OTP2Controller.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OTP2Controller: UIViewController {
 
    // OUTLETS
    @IBOutlet weak var mobileNumber: UITextField!
    
    @IBOutlet weak var OTP: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
        mobileNumber.text! = publicVars.mobileNumber
    }
    
    @IBAction func Next(_ sender: Any) {
        performSegue(withIdentifier: "SignUpController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpController" {
            _ = segue.destination as! SignUpController
        }
    }
    
}
