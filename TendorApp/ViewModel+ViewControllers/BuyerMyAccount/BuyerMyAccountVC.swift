//
//  BuyerMyAccountVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class BuyerMyAccountVC: BaseViewController , headerMenuActionDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    var arrImg = NSArray()
    var arrName = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCommonCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCommonCell")
        
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        
        headerSetup()
        arrName = ["View Profile", "Edit Profile", "Change Password"]
        
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        lblUserName.text = AppPreferenceService.getString(PreferencesKeys.userLastName)
        if let url = AppPreferenceService.getString("logo") {
            self.profileImg.sd_setImage(with: URL(string: url))
        }
    }
    
    func headerSetup()
    {
        headerView.homeDelegate = self
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "My Account"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        tabBarView.moreImg.image = UIImage(named: "MoreSelect")
    }
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension BuyerMyAccountVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCommonCell") as! ProfileCommonCell
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        Cell.profileBtnOutlet.isHidden = true
        Cell.lblName.text = arrName[indexPath.row]
        Cell.lblName.isUserInteractionEnabled = false
//        Cell.lblFieldName.text = arrName[indexPath.row]
        //Cell.imgView.image =  arrImg[(indexPath as NSIndexPath).row] as? UIImage
        
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        switch indexPath.row
        {
        case 0:
            let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewProfileVC") as? EditViewProfileVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerChangePasswordVC") as? BuyerChangePasswordVC
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

