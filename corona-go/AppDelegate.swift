//
//  AppDelegate.swift
//  solocoin
//
//  Created by indie dev on 27/03/20.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var userCurrentLocation: CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        launchStartPage()
        registerForKeyboardNotification()
        setUpForLocalization()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// To open initial page after launch.
    fileprivate func launchStartPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let landingVC = LandingVC.createInstance()
        let nav = UINavigationController(rootViewController: landingVC)
        nav.setNavigationBarHidden(false, animated: false)
        self.window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    private func setUpForLocalization() {
        UserDefaults.standard.set("en", forKey: "language")
        if UserDefaults.standard.value(forKey: "language") == nil{
            UserDefaults.standard.set("en", forKey: "language")
        }
    }
    
    //MARK:- Keyboard Handling Methods
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    /// Notification function called whenever keyboard is revealed.
    ///
    /// - Parameter notification: Notification
    @objc func keyboardWillShow(_ notification: Notification)
    {
        
        if let userInfo = (notification as NSNotification).userInfo
        {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                
                for subview in (UIApplication.topmostViewController()?.view.subviews)! where subview is UITableView
                {
                    (subview as! UITableView).contentInset = contentInsets
                    (subview as! UITableView).scrollIndicatorInsets = contentInsets
                }
                (UIApplication.topmostViewController()?.view.addGesture())
                // ...
            } else {
                // no UIKeyboardFrameEndUserInfoKey entry in userInfo
            }
        } else {
            // no userInfo dictionary in notification
        }
        
    }
    
    /// Notification function called whenever keyboard is dismissed.
    ///
    /// - Parameter notification: notification.
    @objc func keyboardWillHide(_ notification: Notification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        for subview in (UIApplication.topmostViewController()?.view.subviews)! where subview is UITableView
        {
            (subview as! UITableView).contentInset = contentInsets
            (subview as! UITableView).scrollIndicatorInsets = contentInsets
        }
        (UIApplication.topmostViewController()?.view.removeGesture())
    }
    
    func requestUserToAllowForNotification(_ completion: ((_ : Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: UNAuthorizationOptions(arrayLiteral: [.sound, .badge, .alert, .carPlay])) { (granted, error) in
            
            guard granted else { return }
            self.whenNotificationAuthorized()
            completion?(granted)
        }
    }
    
    func whenNotificationAuthorized() {
        UNUserNotificationCenter.current().delegate = self
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
//To register for push notification.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        ///deviceToken
        let devToken: String = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.setValue(devToken, forKey: UserDefaultsUtilsKey.DEVICE_TOKEN.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
}
