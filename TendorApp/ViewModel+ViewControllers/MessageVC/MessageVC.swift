//
//  MessageVC.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class MessageVC: BaseViewController
{
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: MessageVM = {
        return MessageVM()
    }()
    var messageList : [MessageListArray]?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        headerSetup()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.initializeViewModel()
        self.getMessageListDetails()
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
        headerView.lblHeaderTitle.text = "Inbox"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgProfileIcon.image = UIImage(named:"category-icon")
        tabBarView.inboxImg.image = UIImage(named: "InboxSelect")
        headerView.imgProfileIcon.image = UIImage(named: "Search")
        headerView.imgProfileIcon.isHidden = true
        tabBarView.lblInbox.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
    }
    
    func getMessageListDetails(){
        let obj = dashboardParam()
        obj.action = "message"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.getMessageListToAPIService(user: obj)
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
                self!.messageList = (self?.viewModel.MessageListDetails.messageList)!
                self!.tableView.reloadData()
            }
        }
    }
}

extension MessageVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messageList != nil && self.messageList!.count > 0 {
            return messageList!.count
        }else{
            return 0
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MessageListCell
        Cell.intializeCellDetails(cellDic: messageList![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Message", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessageDetailsVC") as? MessageDetailsVC
        vc!.tid = messageList![indexPath.row].tid
        vc!.contactName = messageList![indexPath.row].name
        vc!.messsageTitle = messageList![indexPath.row].title
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

