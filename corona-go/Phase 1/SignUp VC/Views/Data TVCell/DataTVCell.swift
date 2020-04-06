//
//  DataTVCell.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class DataTVCell: UITableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var dataView: UIView!
    
    //MARK:- Constants/Variables
    enum CellType {
        case name
        case email
    }
    var tfData: ((_ :String?)-> Void)?
    
    //MARK:- init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(forCellType type: CellType, userName: String?, email: String?) {
        self.dataView.removeSubviews()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            var customView: SCCustomTextFieldView
            switch type {
            case .name:
                customView  = SCCustomTextFieldView.createInstance(imageName: "ic_profile", tfText: userName, errorText: nil, keyboardTyp: .default)
            case .email:
                customView  = SCCustomTextFieldView.createInstance(imageName: "ic_mail", tfText: email, errorText: nil, keyboardTyp: .emailAddress)
            }
            customView.frame = self.dataView.bounds
            customView.tfText = { [weak self] text in
                guard let weakSelf = self else { return }
                weakSelf.tfData?(text)
            }
            self.dataView.addSubview(customView)
            self.dataView.layoutSubviews()
        }
    }
}
