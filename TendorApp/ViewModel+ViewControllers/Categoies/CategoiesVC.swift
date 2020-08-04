//
//  CategoiesVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 24/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class CategoiesVC: BaseViewController , headerMenuActionDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    var arrImg = NSArray()
    var arrName = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        
        arrImg = [UIImage(named: "menu-home-icon")!, UIImage(named: "register")!,  UIImage(named: "login")!,  UIImage(named: "about")!,  UIImage(named: "terms")!,  UIImage(named: "privacy-policy")!,  UIImage(named: "services")!,  UIImage(named: "faq")!,  UIImage(named: "blog")!,  UIImage(named: "contact-us")!,  UIImage(named: "plan-price")!]
        
        arrName = ["Boby Goods", "Bags/Luggage", "Appliances", "Building Materials", "Camera/Photo", "Cars","Clothing","Commercial Equipments","Computers","Electronics"]
        headerView.homeDelegate = self
        tabBarView.onClickProfileButtonAction = {() -> Void in
            print("Okay")
        }
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
        headerView.lblHeaderTitle.text = "Categories"
        headerView.imgProfileIcon.image = UIImage(named: "Search")
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
    }
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "AdvanceSearchVC") as? AdvanceSearchVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension CategoiesVC : UITableViewDelegate, UITableViewDataSource {
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
            let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

