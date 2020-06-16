//
//  OTPTextField.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/13/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class OTPTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)?
    var defaultChar = "_"
    
    private var isConfigured = false
    private var digitLabels = [UILabel]()
    private lazy var tapRecog: UITapGestureRecognizer = {
        let recog = UITapGestureRecognizer()
        recog.addTarget(self, action: #selector(becomeFirstResponder))
        return recog
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func configure(with count: Int=6){
        guard isConfigured == false else{
            return
        }
        isConfigured.toggle()
        configureTextField()
        
        let labelStackView = creatLabelsStackView(with: count)
        addSubview(labelStackView)
        addGestureRecognizer(tapRecog)
         
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField(){
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func creatLabelsStackView(with count: Int) -> UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1...count{
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = UIFont(name: "Poppins-SemiBold", size: 15)
            label.textColor = .init(red: 247/255, green: 57/255, blue: 90/255, alpha: 1)
            label.text = defaultChar
            label.isUserInteractionEnabled = true
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        return stackView
    }
    
    func clearText(){
        for i in 0..<digitLabels.count{
            digitLabels[i].text = defaultChar
        }
    }
    
    @objc private func textDidChange(){
        guard let text = self.text, text.count <= digitLabels.count else {return}
        for i in 0..<digitLabels.count{
            let currentLabel = digitLabels[i]
            if i < text.count{
                print("ok",i)
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            }else{
                print(i)
                currentLabel.text = defaultChar
            }
        }
        if text.count == digitLabels.count{
            didEnterLastDigit?(text)
        }
    }

}
extension OTPTextField: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("editing",string,"0")
        guard let characterCount = textField.text?.count  else {
            print("ffmmfmf")
            return false
        }
        return characterCount < digitLabels.count || string == ""
    }
}
