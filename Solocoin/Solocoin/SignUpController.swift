//
//  SignUpController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/25/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    // MARK: - IBOUTLETS
    @IBOutlet weak var fullName: UITextField!

    @IBOutlet weak var signUpEmail: UITextField!
    
    @IBOutlet weak var signUpGender: UISegmentedControl!
    
    @IBOutlet weak var signUpBirth: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func accountCreated(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
