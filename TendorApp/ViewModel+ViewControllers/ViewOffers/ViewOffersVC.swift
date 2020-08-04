//
//  ViewOffersVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 31/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class ViewOffersVC: BaseViewController,headerMenuActionDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: OfferListVM = {
        return OfferListVM()
    }()
    var offerList : [OfferList]?
    var tid : String?
    override func viewDidLoad(){
        super.viewDidLoad()
        headerSetup()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initializeViewModel()
        getOfferDetails()
    }
    func getOfferDetails(){
        let obj = OfferParam()
        obj.action = "view-offers-list"
        obj.tid = tid
        viewModel.getOfferListDetailsToAPIService(user: obj)
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
                if self?.viewModel.offerListModel.total != nil {
                    self!.offerList = (self?.viewModel.offerListModel.offerList)!
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
        headerView.lblHeaderTitle.text = "Offers"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        headerView.homeDelegate = self
    }
    func homeMneu() {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func dateFormator(value : String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
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
extension ViewOffersVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if offerList != nil && offerList!.count > 0 {
            return offerList!.count
        }else{
            return 0
        }
    }
    
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ViewOfferCell
        Cell.lblCompanyName.text = offerList![indexPath.row].name
        Cell.lblAmount.text = offerList![indexPath.row].amount
        Cell.lblDays.text = offerList![indexPath.row].completion_days
        let date = dateFormator(value: offerList![indexPath.row].date!)
        Cell.lblDate.text = date
        return Cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 56
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "OfferDetailsVC") as? OfferDetailsVC
        vc!.companyName = offerList![indexPath.row].name
        vc!.id = offerList![indexPath.row].id
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

