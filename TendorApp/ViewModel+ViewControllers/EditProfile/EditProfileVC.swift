//
//  EditProfileVC.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class EditProfileVC: BaseViewController,headerMenuActionDelegate {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrImg = NSArray()
    var arrName = [String]()
    
    lazy var viewModel: ProfileVM = {
        return ProfileVM()
    }()
     var ProfileDetails = ProfileModel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "TendorCell", bundle: Bundle.main), forCellReuseIdentifier: "TendorCell")
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        lblUserName.text = AppPreferenceService.getString(PreferencesKeys.userLastName)
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        
        headerView.homeDelegate = self
        headerView.lblHeaderTitle.text = "View Profile"
        headerView.imgProfileIcon.isHidden = false
        headerView.imgProfileIcon.image = UIImage(named: "EditeIcon")
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        tabBarView.moreImg.image = UIImage(named: "MoreSelect")
        
        arrName = ["Member Since", "Name", "Email", "Country", "Phone", "Address","Company","Company Description"]
        initializeViewModel()
        getDashboardDetails()
    }
    
    func getDashboardDetails(){
        let obj = ProfileParam()
        obj.action = "view-profile"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.getProfileDetailsToAPIService(user: obj)
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
            
            viewModel.refreshViewClosure = {[weak self]() in
                DispatchQueue.main.async {
                    
                    self!.ProfileDetails = (self?.viewModel.ProfileDetails)!
                    if let url = self!.ProfileDetails.logo {
                        let fullUrl = "https://www.tendor.org/" + url
                        self!.profileImg.sd_setImage(with: URL(string: fullUrl))
                        AppPreferenceService.setString(fullUrl, key :"logo")
                    }
                    
                    self!.tableView.reloadData()
                    //self!.categoryCollectionview.reloadData()
                }
            }
        }
    
    func homeMneu(){
        let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewProfileVC") as? EditViewProfileVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func dateFormator(value : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: value ) {
            print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
            return ""
        }
    }
}

extension EditProfileVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell") as! ProfileViewCell
        Cell.lblProfileName.text = arrName[indexPath.row]
        
        switch indexPath.row {
        case 0:
            if let regDate = ProfileDetails.reg_date {
                let date = dateFormator(value: regDate)
                Cell.lblFieldValue.text = date
            }
        case 1:
            if let fname = ProfileDetails.fname {
                Cell.lblFieldValue.text = fname + " " + ProfileDetails.fname!
            }
            
        case 2:
            if let email = ProfileDetails.email {
                Cell.lblFieldValue.text = email
            }
        case 3:
            if let country_id = ProfileDetails.country_id {
                Cell.lblFieldValue.text = country_id
            }
        case 4:
            if let phone = ProfileDetails.phone {
                Cell.lblFieldValue.text = phone
            }
        case 5:
            if let address = ProfileDetails.address {
                Cell.lblFieldValue.text = address
            }
        case 6:
            if let company_name = ProfileDetails.company_name {
                Cell.lblFieldValue.text = company_name
            }
        case 7:
            if let company_desc = ProfileDetails.company_desc {
                Cell.lblFieldValue.text = company_desc
            }
        default:
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        
        return Cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
