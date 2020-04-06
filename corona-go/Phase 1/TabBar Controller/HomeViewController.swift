//
//  HomeViewController.swift
//  corona-go
//
//  Created by indie dev on 05/04/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    
    //MARK:- init Methods
    class func createInstance() -> HomeViewController {
        let cgHomeViewController = UIStoryboard(name: "TabBarStoryBoard", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        return cgHomeViewController
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    
    //MARK:- Helper Methods
    private func setupUI() {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    private func setupNavBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = SCColorUtil.scRedDefaultTheme.value
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: SCColorUtil.scRedDefaultTheme.value)
        let textAttributes = [NSAttributedString.Key.foregroundColor:SCColorUtil.scWhite.value]
        navController.navigationBar.titleTextAttributes = textAttributes
        
        self.title = "HOME".localized()
        self.navigationItem.hidesBackButton = false
        let leftItem = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        leftItem.image = UIImage(named: "ic_app_logo_nav_bar")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItem)
    }
    
    //MARK:- Action Methods
    
}
