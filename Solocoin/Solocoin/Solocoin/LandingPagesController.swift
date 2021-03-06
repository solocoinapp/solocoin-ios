//
//  LandingPagesController.swift
//  Solocoin
//
//  Created by Vamsi Sistla on 4/24/20.
//  Copyright © 2020 Solocoin. All rights reserved.
//

import UIKit

class LandingPageController: UIPageViewController, UIPageViewControllerDataSource {

    lazy var viewControllerList:[UIViewController] = {
       
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let landPage1 = sb.instantiateViewController(withIdentifier: "LandingPage1")
        let landPage2 = sb.instantiateViewController(withIdentifier: "LandingPage2")
        let landPage3 = sb.instantiateViewController(withIdentifier: "LandingPage3")
        let landPage4 = sb.instantiateViewController(withIdentifier: "LandingPage4")
        
        return [landPage1, landPage2, landPage3, landPage4]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        print(UserDefaults.standard.string(forKey: "uuid") ?? "nil")
        print(UserDefaults.standard.string(forKey: "authtoken") ?? "nil")
        /*if let _ = UserDefaults.standard.string(forKey: "uuid"),let _ = UserDefaults.standard.string(forKey: "authtoken"){
            print("in")
            performSegue(withIdentifier: "toDashboard", sender: nil)
        }*/
        if let firstViewController = viewControllerList.first {
        self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*do{
            let x = UserDefaults.standard.string(forKey: "uuid")!
            let y = UserDefaults.standard.string(forKey: "authtoken")!
            self.performSegue(withIdentifier: "toDashboard", sender: nil)
        }catch{
            print("nothing")
        }*/
        if let _ = UserDefaults.standard.string(forKey: "uuid"),let _ = UserDefaults.standard.string(forKey: "authtoken"){
            print("in")
            self.performSegue(withIdentifier: "toDashboard", sender: nil)
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
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
