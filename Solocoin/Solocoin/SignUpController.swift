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
    
    @IBOutlet weak var signUpBirth: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpGender.selectedSegmentIndex = 0
        publicVars.genderSignUp = signUpGender.titleForSegment(at: 0) ?? "error"
        let endEditing = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(endEditing)
    }
    
    @IBAction func genderClicked(_ sender: Any) {
        publicVars.hasGender = true
        publicVars.whichGenderSegment = signUpGender.selectedSegmentIndex
    }

    @IBAction func accountCreated(_ sender: Any) {
        // VARIABLES
        publicVars.fullNameSignUp = fullName.text!
        publicVars.emailSignUp = signUpEmail.text!
        if publicVars.hasGender == true {
            publicVars.genderSignUp = signUpGender.titleForSegment(at: publicVars.whichGenderSegment) ?? "error"
            print(publicVars.genderSignUp)
        }
        // BIRTH
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        components.year = -100
        signUpBirth.minimumDate = calendar.date(byAdding: components, to: currentDate)
        signUpBirth.maximumDate = calendar.date(byAdding: components, to: currentDate)
        // SEGUE
        performSegue(withIdentifier: "permissionSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
