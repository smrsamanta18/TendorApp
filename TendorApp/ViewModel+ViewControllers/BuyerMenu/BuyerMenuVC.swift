//
//  BuyerMenuVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 29/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
class BuyerMenuVC: BaseViewController
{
    @IBOutlet weak var profileImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblProfileName: UILabel!
    var arrImg = NSArray()
    var arrName = [String]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        headerSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MenuBuyerCell", bundle: Bundle.main), forCellReuseIdentifier: "MenuBuyerCell")
        
        arrImg = [UIImage(named: "menu-home-icon")!, UIImage(named: "register")!,  UIImage(named: "login")!,  UIImage(named: "about")!,  UIImage(named: "terms")!,  UIImage(named: "privacy-policy")!,  UIImage(named: "services")!,  UIImage(named: "faq")!,  UIImage(named: "blog")!]
        
        let namevaleu = AppPreferenceService.getString(PreferencesKeys.userLastName)
        if namevaleu != nil{
            arrName = ["Dashboard", "My Account","My Tendor List" ,"Logout"]
            self.lblProfileName.text = namevaleu
        }else{
            arrName = ["Register", "Login", "Terms Condition", "Privecy policy", "Faq", "About","Blog ","Contact Us","Tendor Tips"]
            self.lblProfileName.text = "Guest"
        }
        profileImgView.layer.borderWidth = 2
        profileImgView.layer.masksToBounds = false
        //profileImgView.layer.borderColor = (UIColor.green as! CGColor)
        profileImgView.layer.cornerRadius = profileImgView.frame.height/2
        profileImgView.clipsToBounds = true
        
        if let url = AppPreferenceService.getString("logo") {
            self.profileImgView.sd_setImage(with: URL(string: url))
        }
    }
    
    func headerSetup(){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String

        headerView.lblHeaderTitle.text = "Menu - V_" + version
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        tabBarView.moreImg.image = UIImage(named: "MoreSelect")
        tabBarView.lblMore.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
    }
    
    func navigateToTermsPage(header : String , url : String){
        
        let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC
        vc!.urlValue = url
        vc!.headerValue = header
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension BuyerMenuVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "MenuBuyerCell") as! MenuBuyerCell
        Cell.lblMenuName.text = arrName[indexPath.row]
        
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("You selected cell #\(indexPath.row)!")
        
        let namevaleu = AppPreferenceService.getString(PreferencesKeys.userName)
        if namevaleu != nil{
            
            switch indexPath.row
            {
            case 0:
                let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerDashboardVC") as? BuyerDashboardVC
                self.navigationController?.pushViewController(vc!, animated: true)
            
            case 1:
                let vc = UIStoryboard.init(name: "EditProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMyAccountVC") as? BuyerMyAccountVC
                self.navigationController?.pushViewController(vc!, animated: true)
            case 2:
                let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
                vc!.headerTitle = "My Tendor"
                self.navigationController?.pushViewController(vc!, animated: true)
            case 3:
                AppPreferenceService.removeString(PreferencesKeys.userToken)
                AppPreferenceService.removeString(PreferencesKeys.userID)
                AppPreferenceService.removeString(PreferencesKeys.userLastName)
                AppPreferenceService.setInteger(IS_LOGGED_OUT, key: PreferencesKeys.loggedInStatus)
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
                self.navigationController?.pushViewController(vc!, animated: false)
            default:
                break
            }
        }else{
            switch indexPath.row
            {
            case 0:
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
                self.navigationController?.pushViewController(vc!, animated: false)
            case 1:
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
                self.navigationController?.pushViewController(vc!, animated: false)
            case 2:
                navigateToTermsPage(header: "Terms & Conditions", url: "https://www.tendor.org/info/terms-and-conditions")
            case 3:
                navigateToTermsPage(header: "Privacy Policy", url: "https://www.tendor.org/info/privacy-policy")
            case 4:
                navigateToTermsPage(header: "Faq For Buyer", url: "https://www.tendor.org/faq")
            case 5:
                navigateToTermsPage(header: "About Us", url: "https://www.tendor.org/info/about-us")
            case 6:
                navigateToTermsPage(header: "Blog", url: "https://www.tendor.org/blog")
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}


