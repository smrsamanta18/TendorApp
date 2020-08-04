//
//  NotificationVC.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class NotificationVC: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: NotificationVM = {
        return NotificationVM()
    }()
    var NotificationDetails = NotificationModel()
    var notificationList : [NotificationList]?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        initializeViewModel()
        viewModel.getNotificationToAPIService(token: AppPreferenceService.getString(PreferencesKeys.userToken)!)
    }
    func headerSetup(){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Notification"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgProfileIcon.image = UIImage(named:"Search")
        tabBarView.notificationImg.image = UIImage(named: "NotificationSelect")
        tabBarView.lblNotication.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
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
                if self?.viewModel.NotificationDetails.total != nil {
                    self!.notificationList = (self?.viewModel.NotificationDetails.notificationList)!
                }
                self!.tableView.reloadData()
                //self!.categoryCollectionview.reloadData()
            }
        }
    }
    
}
extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notificationList != nil  && notificationList!.count > 0 {
            return notificationList!.count
        }else{
            return 0
        }
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationListCell
        Cell.intializeCellDetails(CellDic: notificationList![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

