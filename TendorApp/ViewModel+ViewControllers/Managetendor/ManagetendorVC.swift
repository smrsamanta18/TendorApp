//
//  ManagetendorVC.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class ManagetendorVC: BaseViewController , headerMenuActionDelegate{
    @IBOutlet weak var tableView: UITableView!

    var headerTitle : String?
    lazy var viewModel: MyTendorVM = {
        return MyTendorVM()
    }()
    var myTendorList : [MyTendorList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        headerSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getDashboardDetails()
        initializeViewModel()
    }
    func getDashboardDetails(){
        let obj = MyTendorParam()
        obj.action = "my-tendors"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.getMyTendorToAPIService(user: obj)
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
                if self?.viewModel.MyTendorDetails.total != nil {
                    self!.myTendorList = (self?.viewModel.MyTendorDetails.myTendorList)!
                }
                self!.tableView.reloadData()
                //self!.categoryCollectionview.reloadData()
            }
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
        headerView.lblHeaderTitle.text = headerTitle
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        headerView.homeDelegate = self
        tabBarView.homeImg.image = UIImage(named: "HomeSelect")
    }
    
    func homeMneu() {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
  }
extension ManagetendorVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myTendorList != nil  && myTendorList!.count > 0 {
            return myTendorList!.count
        }else{
            return 0
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ManageTendorCell
        Cell.initializeCellDetails(cellDic: myTendorList![indexPath.row])
        Cell.btnAdditionalInfo.addTarget(self, action: #selector(ManagetendorVC.additionalInfoTapped(_:)), for: UIControl.Event.touchUpInside)
        Cell.btnAdditionalInfo.tag = indexPath.row
        Cell.btnViewOffer.addTarget(self, action: #selector(ManagetendorVC.btnViewOfferTapped(_:)), for: UIControl.Event.touchUpInside)
        Cell.btnViewOffer.tag = indexPath.row
        Cell.btnManageOffer.addTarget(self, action: #selector(ManagetendorVC.btnManageOfferTapped(_:)), for: UIControl.Event.touchUpInside)
        Cell.btnManageOffer.tag = indexPath.row
        Cell.btnFeedBack.addTarget(self, action: #selector(ManagetendorVC.btnFeedBackTapped(_:)), for: UIControl.Event.touchUpInside)
        Cell.btnFeedBack.tag = indexPath.row
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (self.myTendorList![indexPath.row].tender_description!.count) > 150 {
             //return UITableView.automaticDimension
            return 220
        } else{
             return 160
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
        vc?.tID = myTendorList![indexPath.row].tid
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func additionalInfoTapped(_ sender: UIButton!)
    {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "TendorAdditionalInfoVC") as? TendorAdditionalInfoVC
        vc!.tid = myTendorList![sender.tag].tid
        self.navigationController?.pushViewController(vc!, animated: true)
        print(sender.tag)
    }
     @objc func btnViewOfferTapped(_ sender: UIButton!)
    {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewOffersVC") as? ViewOffersVC
        vc!.tid = myTendorList![sender.tag].tid
        self.navigationController?.pushViewController(vc!, animated: true)
    }
     @objc func btnManageOfferTapped(_ sender: UIButton!)
    {
        let vc = UIStoryboard.init(name: "Message", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessageVC") as? MessageVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
     @objc func btnFeedBackTapped(_ sender: UIButton!)
    {
        let vc = UIStoryboard.init(name: "FeedBack", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
        vc!.tid = myTendorList![sender.tag].tid
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 56
//    }
}
