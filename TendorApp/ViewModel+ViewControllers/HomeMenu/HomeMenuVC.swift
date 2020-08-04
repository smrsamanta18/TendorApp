//
//  HomeMenuVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 24/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class HomeMenuVC: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var arrImg = NSArray()
    var arrName = [String]()

    @IBOutlet weak var lblTendorName: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerSetup()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        
        arrImg = [UIImage(named: "menu-home-icon")!, UIImage(named: "register")!,  UIImage(named: "login")!,  UIImage(named: "about")!,  UIImage(named: "terms")!,  UIImage(named: "privacy-policy")!,  UIImage(named: "services")!,  UIImage(named: "faq")!,  UIImage(named: "blog")!,  UIImage(named: "contact-us")!,  UIImage(named: "plan-price")!,  UIImage(named: "tendor-tips")!]
        arrName = ["Home", "Register", "Log In", "About", "Term & Conditions", "Privacy Policy","Services ","Faq","Blog","Contact Us","Plan & Price","Tendor Tips"]
        
        self.lblTendorName.text = AppPreferenceService.getString(PreferencesKeys.userLastName)
    }
    
    func headerSetup()
    {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Home Menu"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
    }
     
}

extension HomeMenuVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        
        Cell.lblName.text = arrName[indexPath.row]
        Cell.imgView.image =  arrImg[(indexPath as NSIndexPath).row] as? UIImage
        Cell.imgRight.image = UIImage(named: "menu-right-arrow")
        Cell.imgSeparator.image = UIImage(named: "")
        Cell.imgSeparator.backgroundColor = UIColor.lightGray
        
        return Cell
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\(indexPath.row)!")
        switch indexPath.row
        {
        case 0:
            let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerDashboardVC") as? BuyerDashboardVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 2:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
            self.navigationController?.pushViewController(vc!, animated: true)
        case 6:
            let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "CategoiesVC") as? CategoiesVC
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}


