//
//  WelcomeViewController.swift
//  Solocoin
//
//  Created by Mishaal Kandapath on 6/12/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var welcomText: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var mainpic: UIImageView!
    //@IBOutlet weak var forwardBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomText.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        mainpic.translatesAutoresizingMaskIntoConstraints = false
        //forwardBtn.translatesAutoresizingMaskIntoConstraints = false
        // Do any additional setup after loading the view.
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.performSegue(withIdentifier: "next", sender: nil)
        }
    }
    
    func setView(){
        welcomText.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/10).isActive = true
        welcomText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomText.widthAnchor.constraint(equalToConstant: 3*view.frame.width/4).isActive = true
        welcomText.heightAnchor.constraint(equalToConstant: view.frame.height/17).isActive = true
        logo.topAnchor.constraint(equalTo: welcomText.bottomAnchor, constant: view.frame.height/10).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        logo.heightAnchor.constraint(equalToConstant: view.frame.height/4).isActive = true
        mainpic.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10).isActive = true
        mainpic.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        mainpic.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mainpic.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
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
