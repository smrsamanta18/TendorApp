//
//  AdvanceSearchVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 29/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class AdvanceSearchVC: BaseViewController
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
        
        arrName = ["Select Tendor Type", "Select Category", "Select Country", "Search word"]
    }
    @IBAction func btnSearchTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC
        vc!.searchTest = ""
        vc?.isNavigateFromCat = true
        self.navigationController?.pushViewController(vc!, animated: true)
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
        headerView.lblHeaderTitle.text = "Advance Search"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgProfileIcon.image = UIImage(named:"AdvanceSearch")
        tabBarView.homeImg.image = UIImage(named: "HomeSelect")
        tabBarView.lblHome.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
    }
    func captureImage(){
        
    }
}

extension AdvanceSearchVC : UITableViewDelegate, UITableViewDataSource , profileImageCaptureDelegate{
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
        Cell.imgSeparator.image = UIImage(named: "")
        Cell.imgRight.image = UIImage(named: "down-arrow")
        Cell.imgSeparator.backgroundColor = UIColor.lightGray
        Cell.delegate = self
        return Cell
    }
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        print("You selected cell #\(indexPath.row)!")
//        switch indexPath.row
//        {
//        case 0:
//            let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
//            self.navigationController?.pushViewController(vc!, animated: true)
//        default:
//            break
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

