//
//  SignUpVC.swift
//  solocoin
//
//  Created by indie dev on 30/03/20.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Constants/Variables
    private var dataModel = SignUpModel()
    
    //MARK:- init Methods
    class func createInstance() -> SignUpVC {
        let scSignUpVC = SignUpVC(nibName: "SignUpVC", bundle: nil)
        return scSignUpVC
    }
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:- Helper Methods
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AppIconHeaderCell.self)
        tableView.register(DataTVCell.self)
        tableView.register(DOBTVCell.self)
        tableView.register(GenderTVCell.self)
        tableView.register(CreateTVCell.self)
    }
    
    private func setupNavBar() {
        guard let navController = self.navigationController else { return }
        navController.navigationBar.barTintColor = .white
        SCNavigationBarUtil.customiseUiNavigationBarTransparent(navController, color: .white)
        
        self.navigationItem.hidesBackButton = true
    }
    
    //MARK:- Action Methods
    private func openDatePicker(forSelectedDate date: String?) {
        let datePicker = CustomDatePicker.createInstance(withSelectedDate: date, withFormat: SCDateFormats.DOB_DATE_CONSTANT.type)
        datePicker.dateDelegate = self
        datePicker.modalPresentationStyle = .overCurrentContext
        self.present(datePicker, animated: true, completion: nil)
    }
    private func nextBtnTapped() {
        self.view.hideKeyboard()
        navigateToPermissionsVC()
    }
    
    private func skipBtnTapped() {
        self.view.hideKeyboard()
        navigateToPermissionsVC()
    }
    
    private func navigateToPermissionsVC() {
        let vc = SetPermissionsVC.createInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SignUpVC: SelectedDateProtocol {
    func selectedDate(selectedDate: Date) {
        dataModel.dob = selectedDate.toString(dateFormat: SCDateFormats.DOB_DATE_CONSTANT.type)
        tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
    
    
}

//MARK:- UITableViewDelegate, UITableViewDataSource Methods
extension SignUpVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 80.0
        }
        if indexPath.row == 1 || indexPath.row == 2 {
            return 70.0
        }
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: AppIconHeaderCell.xibName, for: indexPath) as! AppIconHeaderCell
            cell.selectionStyle = .none
            return cell
        case 1,2:
            let cell = tableView.dequeueReusableCell(withIdentifier: DataTVCell.xibName, for: indexPath) as! DataTVCell
            cell.configCell(forCellType: indexPath.row == 1 ? .name : .email, userName: dataModel.name, email: dataModel.email)
            cell.tfData = { [weak self] text in
                guard let weakSelf = self else { return }
                if indexPath.row == 1{
                    weakSelf.dataModel.name = text
                }else{
                    weakSelf.dataModel.email = text
                }
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: DOBTVCell.xibName, for: indexPath) as! DOBTVCell
            cell.dobBTN.setTitle(dataModel.dob, for: .normal)
            cell.errorLB.isHidden = true
            cell.dobBTNTapped = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.view.hideKeyboard()
                weakSelf.openDatePicker(forSelectedDate: weakSelf.dataModel.dob)
            }
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: GenderTVCell.xibName, for: indexPath) as! GenderTVCell
            cell.configCell(withGender: dataModel.gender)
            cell.genderBtnTapped = { [weak self] text in
                guard let weakSelf = self else { return }
                weakSelf.view.hideKeyboard()
                weakSelf.dataModel.gender = text
            }
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: CreateTVCell.xibName, for: indexPath) as! CreateTVCell
            cell.selectionStyle = .none
            cell.configureCell(withBtnTitle: "CREATE_ACCOUNT".localized(), skipTitle: "SKIP_FOR_NOW".localized())
            cell.createAccountBtnTapped = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.nextBtnTapped()
            }
            cell.skipNowBtnTapped = { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.skipBtnTapped()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
