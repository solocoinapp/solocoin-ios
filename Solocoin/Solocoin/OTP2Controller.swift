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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumber.text! = mobile
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Next(_ sender: Any) {
        
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
