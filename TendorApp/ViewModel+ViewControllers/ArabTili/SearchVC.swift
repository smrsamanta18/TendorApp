//
//  ArabTiliVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 24/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import SDWebImage
class SearchVC: BaseViewController{
    @IBOutlet weak var tableView: UITableView!

    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var tendorDetails = TendorDetailsModel()
    var tID : String?
    @IBOutlet weak var serviceImgName: UIImageView!
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var imgBGView: UIView!
    @IBOutlet weak var imgMainView: RoundUIView!
    @IBOutlet weak var imgFullView: UIImageView!
    @IBOutlet weak var imgViewClose: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        imgViewClose.layer.cornerRadius = imgViewClose.frame.width/2
        
        self.imgBGView.isHidden = true
        self.imgMainView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SearchtableCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchtableCell")
        headerSetup()
        initializeViewModel()
        getTendorDetails()
    }
    
    func getTendorDetails(){
        let obj = TendorDetailsParam()
        obj.action = "tendor-details"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = tID
        viewModel.getTendorDetailsToAPIService(user: obj)
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
                self!.tendorDetails = (self?.viewModel.tendorDetails)!
                self!.lblServiceName.text = self!.tendorDetails.category
                if let url = self!.tendorDetails.attachment {
                    let fullUrl = "https://www.tendor.org/" + url
                    self!.imgFullView.sd_setImage(with: URL(string: fullUrl))
                }
                self!.tableView.reloadData()
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
        headerView.lblHeaderTitle.text = "Tendor Details"
        headerView.imgProfileIcon.image = UIImage(named: "Search")
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
    }
    
    func applyDelegate(){
        self.showAlertWithSingleButton(title: commonAlertTitle, message: "You need to register as supplier to apply this tendor", okButtonText: okText, completion: nil)
    }
    
    func fullImageDelegate(){
        self.imgBGView.isHidden = false
        self.imgMainView.isHidden = false
    }
    
    @IBAction func btnViewImgClose(_ sender: Any) {
        self.imgBGView.isHidden = true
        self.imgMainView.isHidden = true
    }
}


//user_id
extension SearchVC : UITableViewDelegate, UITableViewDataSource , applyMethodDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tendorDetails != nil {
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  if indexPath.row == 0 {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "SearchtableCell") as! SearchtableCell
            Cell.lblRefferanceNumber.text = tendorDetails.reference
            Cell.lblTitile.text = tendorDetails.title
            Cell.lblCategory.text = tendorDetails.category
            Cell.lblDescription.text = tendorDetails.tender_description
            Cell.lblOpenDate.text = tendorDetails.opening_date
            Cell.lblClosingDate.text = tendorDetails.exp_date
            Cell.lblStatus.text = tendorDetails.status
            Cell.delegate = self
            
            if let url = self.tendorDetails.attachment {
                let fullUrl = "https://www.tendor.org/" + url
                Cell.imgViewDetails.sd_setImage(with: URL(string: fullUrl))
            }
            
            if AppPreferenceService.getString(PreferencesKeys.userID) == tendorDetails.user_id {
                Cell.applyVIew.isHidden = true
            }else{
                Cell.applyVIew.isHidden = false
            }
            return Cell
//        }else{
//            let Cell = tableView.dequeueReusableCell(withIdentifier: "SearchtableImageCell") as! SearchtableImageCell
//            if let url = self.tendorDetails.attachment {
//                let fullUrl = "https://www.tendor.org/" + url
//                Cell.imgViewDetails.sd_setImage(with: URL(string: fullUrl))
//            }
//            return Cell
        //}
    }
    
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "AdvanceSearchVC") as? AdvanceSearchVC
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 470
    }
}
