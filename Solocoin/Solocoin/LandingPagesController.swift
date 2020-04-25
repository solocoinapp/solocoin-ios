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
        
        return [landPage1, landPage2, landPage3]
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self

        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
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