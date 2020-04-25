//
//  OTPController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/24/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OTPController: UIViewController {

    @IBOutlet weak var mobileNumber: UITextField!
    
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    @IBAction func OTPNext(_ sender: Any) {

           guard let _mobileNumber = mobileNumber else {return}
           if isValidMobile(phone: _mobileNumber) {
               
               self.navigationController?.pushViewController(otpSuccessVC, animated: true)
           }
       }

    
    // MARK: FUNCTIONS
    // Checks to see if an object (mobile number, email...)
    func isValidMobile(phone: UITextField) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
    
   /*
    func isValidMobile(object:UITextField) -> Bool{
        if object.count == 10 {
            return true
        }
        else {
            return
        }
        
        
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
