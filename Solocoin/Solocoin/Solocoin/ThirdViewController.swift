//
//  ThirdViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/12/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var solocoinImage: UIImageView!
    @IBOutlet weak var mainpic: UIImageView!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        solocoinImage.translatesAutoresizingMaskIntoConstraints = false
        mainpic.translatesAutoresizingMaskIntoConstraints = false
        infoText.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        setLayout()
        nextButton.layer.cornerRadius = nextButton.frame.width/20
    }
    func setLayout(){
       /* mainpic.topAnchor.constraint(equalTo: solocoinImage.bottomAnchor, constant: 30).isActive = true
        mainpic.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        mainpic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        mainpic.heightAnchor.constraint(equalToConstant: view.frame.height/2.5).isActive = true
        infoText.topAnchor.constraint(equalTo: mainpic.bottomAnchor, constant:10).isActive = true
        infoText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        nextButton.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: 8).isActive = true*/
        solocoinImage.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/16).isActive = true
        solocoinImage.heightAnchor.constraint(equalToConstant: view.frame.height/12).isActive = true
        solocoinImage.widthAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        solocoinImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainpic.topAnchor.constraint(equalTo: solocoinImage.bottomAnchor, constant: view.frame.height/12).isActive = true
        mainpic.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainpic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mainpic.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        infoText.topAnchor.constraint(equalTo: mainpic.bottomAnchor, constant: 8).isActive = true
        infoText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        infoText.heightAnchor.constraint(equalToConstant: mainpic.frame.height/3).isActive = true
        nextButton.topAnchor.constraint(equalTo: infoText.bottomAnchor, constant: view.frame.height/15).isActive = true
        //nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/17).isActive  = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: view.frame.height/13).isActive = true
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
