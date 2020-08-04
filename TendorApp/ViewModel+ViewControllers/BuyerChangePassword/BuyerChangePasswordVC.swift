//
//  BuyerChangePasswordVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class BuyerChangePasswordVC: BaseViewController , headerMenuActionDelegate{
    @IBOutlet weak var tableView: UITableView!
    var arrImg = NSArray()
    var arrName = [String]()
    @IBOutlet weak var profileImg: UIImageView!
    var changePass = ChangeParam()
    
    lazy var viewModel: ProfileVM = {
        return ProfileVM()
    }()
    @IBOutlet weak var lblProfileName: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "ProfileCommonCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCommonCell")
        
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        headerSetup()
        arrName = ["Old Password", "New Password", "Confirm Password"]
        lblProfileName.text = AppPreferenceService.getString(PreferencesKeys.userLastName)
    }
    
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func headerSetup(){
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        if let url = AppPreferenceService.getString("logo") {
            self.profileImg.sd_setImage(with: URL(string: url))
        }
        headerView.homeDelegate = self
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Change Password"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        tabBarView.moreImg.image = UIImage(named: "MoreSelect")
        self.initializeViewModel()
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshUpdateViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if self?.viewModel.updateProfile.message != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.updateProfile.message)!, okButtonText: okText, completion: {
                        self!.navigationController?.popViewController(animated: true)
                    })
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Something went to wrong, please try again.", okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        changePass.action = "change-password"
        changePass.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.postChangePasswordToAPIService(user: changePass)
    }
}

extension BuyerChangePasswordVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        Cell.lblName.placeholder = arrName[indexPath.row]
        Cell.imgView.isHidden = true
        Cell.lblName.isSecureTextEntry = true
        Cell.lblName.tag = indexPath.row
        Cell.lblName.delegate = self
        Cell.profileBtnOutlet.isHidden = true
        switch indexPath.row {
        case 0:
            Cell.lblName.text = changePass.old_password
        case 1:
            Cell.lblName.text = changePass.new_password
        case 2:
            Cell.lblName.text = changePass.conf_password
        default:
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension BuyerChangePasswordVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        
        
        switch textField.tag {
        case 0:
            changePass.old_password = updateText as String
        case 1:
            changePass.new_password = updateText as String
        case 2:
            changePass.conf_password = updateText as String
        default:
            break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
