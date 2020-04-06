//
//  CustomDatePicker.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

protocol SelectedDateProtocol {
    func selectedDate(selectedDate: Date)
}

class CustomDatePicker: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    //MARK:- Constants/Variables
    var dateDelegate:SelectedDateProtocol?
    private var selectedDate: String? = nil
    private var dateFormat: String!
    
    //MARK:- init Methods
    class func createInstance(withSelectedDate selected: String?, withFormat format: String) -> CustomDatePicker {
        let scCustomDatePicker = CustomDatePicker(nibName: "CustomDatePicker", bundle: nil)
        scCustomDatePicker.selectedDate = selected
        scCustomDatePicker.dateFormat = format
        return scCustomDatePicker
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        displayDate()
        configConstants()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func displayDate() {
        datePicker.date = SCDateUtils.getDate(forString: selectedDate, withFormat: dateFormat) ?? Date()
        datePicker.maximumDate = Date()
    }
    
    private func configConstants() {
        selectBtn.backgroundColor = SCColorUtil.scRedDefaultTheme.value
        cancelBtn.backgroundColor = SCColorUtil.scWhite.value
        
        selectBtn.setTitleColor(SCColorUtil.scWhite.value, for: .normal)
        cancelBtn.setTitleColor(SCColorUtil.scBlackGray.value, for: .normal)
        
        selectBtn.titleLabel?.font = SCFonts.defaultStandard(size: 14).value
        cancelBtn.titleLabel?.font = SCFonts.defaultStandard(size: 14).value
    }
    
    // MARK:- Action Method.
    
    /// Select button.
    ///
    /// - Parameter sender: UIButton
    @IBAction func selectButtonTapped(_ sender: UIButton)
    {
       dateDelegate?.selectedDate(selectedDate: datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Cancel button.
    ///
    /// - Parameter sender: UIButton
    @IBAction func cancelButtonTapped(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
