//
//  LandingPageController.swift
//  corona-go
//
//  Created by Vamsi Sistla on 4/24/20.
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
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
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
