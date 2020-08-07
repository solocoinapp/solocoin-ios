//
//  OpeningViewControllers.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/12/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class FirstOpeningViewControllers: UIViewController {
    
    @IBOutlet weak var solocoinImage: UIImageView!
    @IBOutlet weak var mainpic: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var paginator: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        solocoinImage.translatesAutoresizingMaskIntoConstraints = false
        mainpic.translatesAutoresizingMaskIntoConstraints = false
        infoText.translatesAutoresizingMaskIntoConstraints = false
        paginator.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        skip.translatesAutoresizingMaskIntoConstraints = false
        
        //usercheck
        if UserDefaults.standard.string(forKey: "check") == nil{
            skip.isUserInteractionEnabled = false
            skip.isHidden = true
        }else{
            skip.isUserInteractionEnabled = true
            skip.isHidden = false
        }
        // Do any additional setup after loading the view.
        setLayout()
        nextButton.layer.cornerRadius = nextButton.frame.width/25
    }
    func setLayout(){
        solocoinImage.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/14).isActive = true
        solocoinImage.heightAnchor.constraint(equalToConstant: view.frame.height/8).isActive = true
        solocoinImage.widthAnchor.constraint(equalToConstant: view.frame.width/4).isActive = true
        solocoinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainpic.topAnchor.constraint(equalTo: solocoinImage.bottomAnchor, constant: view.frame.height/15 ).isActive = true
        mainpic.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainpic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainpic.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        infoText.topAnchor.constraint(equalTo: mainpic.bottomAnchor, constant: 8).isActive = true
        infoText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        //infoText.heightAnchor.constraint(equalToConstant: self.view.frame.height/16.8).isActive = true
        paginator.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: self.view.frame.height/31).isActive = true
        paginator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        paginator.widthAnchor.constraint(equalToConstant: 29).isActive = true
        paginator.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: paginator.bottomAnchor, constant: self.view.frame.height/26).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: view.frame.height/15).isActive = true
        //nextButton.topAnchor.constraint(greaterThanOrEqualTo: infoText.bottomAnchor, constant: view.frame.height/15).isActive = true
        skip.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 8).isActive = true
        skip.widthAnchor.constraint(equalToConstant: nextButton.frame.width/6).isActive = true
        skip.heightAnchor.constraint(equalToConstant: nextButton.frame.height/1.5).isActive = true
        skip.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //skip.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        skip.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10).isActive = true
        
        /*skip.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        skip.widthAnchor.constraint(equalToConstant: nextButton.frame.width/6).isActive = true
        skip.heightAnchor.constraint(equalToConstant: nextButton.frame.height/1.5).isActive = true
        skip.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nextButton.bottomAnchor.constraint(equalTo: skip.topAnchor, constant: -8).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: view.frame.height/13).isActive = true
        nextButton.topAnchor.constraint(greaterThanOrEqualTo: infoText.bottomAnchor, constant: view.frame.height/15).isActive = true*/
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
