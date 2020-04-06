//
//  PermissionsVC.swift
//  corona-go
//
//  Created by indie dev on 02/04/20.
//

import UIKit
import CoreLocation

class PermissionsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Constants/Variables     
    private var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    private var userSelectedImage: UIImage? = nil
    
    //MARK:- init Methods
    class func createInstance() -> PermissionsVC {
        let cgPermissionsVC = PermissionsVC(nibName: "PermissionsVC", bundle: nil)
        return cgPermissionsVC
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavBar()
    }
    
    //MARK:- Helper Methods
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileImageCell.self)
        tableView.register(PermissionButtonCell.self)
        tableView.register(CreateTVCell.self)
    }
    
    private func setupNavBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = .white
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: .white)
        
        self.navigationItem.hidesBackButton = true
        self.title = "PERMISSIONS".localized()
        let textAttributes = [NSAttributedString.Key.foregroundColor:SCColorUtil.scRedDefaultTheme.value]
        navController.navigationBar.titleTextAttributes = textAttributes
    }
    //MARK:- Action Methods
    @objc private func nextBtnTapped() {
        let homeVC = HomeViewController.createInstance()
        homeVC.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    /// When tapped on permission Location/Notification.
    private func permissionBtnTapped(forIndexPath row: Int) {
        if row == 1 {
            onTapOfLocation()
        }else{
            onTapOfNotification()
        }
    }
    
    /// When location button is tapped
    private func onTapOfLocation() {
        updateStatus(status: CLLocationManager.authorizationStatus())
    }
    
    /// Check whether user has given permission for location.
    private func updateStatus(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.reloadLocationRow(isAuth: true)
            break
        case .denied:
            SCViewUtils.gotoSettingsApp()
            self.reloadLocationRow(isAuth: false)
            break
        case .notDetermined:
            self.determineCurrentLocation()
            break
        default:
            break
        }
    }
    
    /// To reload location row based on permission.
    private func reloadLocationRow(isAuth auth: Bool) {
        UserDefaults.standard.setValue(auth, forKey: UserDefaultsUtilsKey.APP_LOCATION.rawValue)
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
    
    /// To reload notification row based on permission.
    private func reloadNotificationRow(isAuth auth: Bool) {
        UserDefaults.standard.setValue(auth, forKey: UserDefaultsUtilsKey.APP_NOTIFICATION.rawValue)
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        }
    }
    
    /// When notification button is tapped
    private func onTapOfNotification() {
        DispatchQueue.main.async {
            /// Appdelegate Reference
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                switch settings.authorizationStatus {
                case .notDetermined:
                    appdelegate.requestUserToAllowForNotification { (isGranted) in
                        self.reloadNotificationRow(isAuth: isGranted)
                    }
                case .denied:
                    SCViewUtils.gotoSettingsApp()
                    self.reloadNotificationRow(isAuth: false)
                case .authorized:
                    appdelegate.whenNotificationAuthorized()
                    self.reloadNotificationRow(isAuth: true)
                    break
                case .provisional:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
        
}
//MARK:- UITableView delegates
extension PermissionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200.0
        }
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.xibName, for: indexPath) as! ProfileImageCell
            cell.setUpConstant()
            if let _userSelectedImage = userSelectedImage {
                cell.cameraIView.contentMode = .scaleAspectFill
                cell.cameraIView.image = _userSelectedImage
            }
            cell.selectionStyle = .none
            return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PermissionButtonCell.xibName, for: indexPath) as! PermissionButtonCell
            cell.configureCell(withBtnTitle: indexPath.row == 1 ? "ACCESS_LOCATION".localized() : "ALLOW_NOTIFICATIONS".localized())
            cell.permissionBtnTapped = { [weak self] in
            guard let weakSelf = self else { return }
                weakSelf.permissionBtnTapped(forIndexPath: indexPath.row)
            }
            switch indexPath.row {
            case 1:
                cell.defaultBtnUISetup()
                if let appLoc = UserDefaults.standard.value(forKey: UserDefaultsUtilsKey.APP_LOCATION.rawValue) as? Bool,  appLoc {
                    cell.changeUIConstant()
                }
                break
            case 2:
                cell.defaultBtnUISetup()
                if let appNotif = UserDefaults.standard.value(forKey: UserDefaultsUtilsKey.APP_NOTIFICATION.rawValue) as? Bool,  appNotif {
                    cell.changeUIConstant()
                }
               break
            default:
                break
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateTVCell.xibName, for: indexPath) as! CreateTVCell
            cell.selectionStyle = .none
            cell.configureCell(withBtnTitle: "CONTINUE".localized(), skipTitle: "")
            cell.skipNowBtn.isHidden = true
            cell.createAccountBtnTapped = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.nextBtnTapped()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            showPhotoPickerOption()
        }else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40.0))
        sectionFooterView.backgroundColor = SCColorUtil.scWhite.value
        let sectionFooterLbl = UILabel(frame: CGRect(x: 16.0, y: 0, width: sectionFooterView.frame.width - 24.0, height: sectionFooterView.bounds.height))
        
        sectionFooterLbl.font = SCFonts.defaultMedium(size: 12.0).value
        sectionFooterLbl.numberOfLines = 2
        sectionFooterLbl.textAlignment = .center
        sectionFooterLbl.text = "SECURED_DATA".localized()
        sectionFooterLbl.textColor = SCColorUtil.scGray.value
        
        sectionFooterView.addSubview(sectionFooterLbl)
        return sectionFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40.0
    }
}

//MARK:- Location Permission
extension PermissionsVC: CLLocationManagerDelegate {
    private func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
       //
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        self.reloadLocationRow(isAuth: true)
        DispatchQueue.main.async {
        /// Appdelegate Reference
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.userCurrentLocation = userLocation
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

}

//MARK:- Camera/Gallery Permission
extension PermissionsVC: PhotoCameraGalleryHandlerProtocol {
    
    /// To show upload image picker.
    private func showPhotoPickerOption() {
        let photoHandler: SCCameraGalleryHandler = SCCameraGalleryHandler.init(onViewController: self.parent, titleText: nil, galleryText: nil, cameraText: nil)
        photoHandler.delegate = self
    }
    
    /// Delegate method conforming to PhotoCameraGalleryHandlerProtocol
    /// - Parameter uploadedImage: image selected by user either from gallery/camera.
    func didUploadImage(_ uploadedImage: UIImage) {
        userSelectedImage = uploadedImage
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
    }
}
