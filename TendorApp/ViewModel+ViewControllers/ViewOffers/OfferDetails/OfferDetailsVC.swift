//
//  OfferDetailsVC.swift
//  TendorApp
//
//  Created by Samir Samanta on 21/02/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class OfferDetailsVC: BaseViewController ,headerMenuActionDelegate{

    @IBOutlet weak var meesageTableView: UITableView!
    var arrName = [String]()
    @IBOutlet weak var offerDetailsTable: UITableView!
    lazy var viewModel: OfferListVM = {
        return OfferListVM()
    }()
    var offerDetailsModel = ViewOfferDetailsModel()
    
    lazy var DashboardviewModel: DashboardVM = {
        return DashboardVM()
    }()
    var tendorDetails = TendorDetailsModel()
    
    lazy var messageviewModel: MessageVM = {
        return MessageVM()
    }()
    var messageDetails : [MessageDetailsArray]?
    
    @IBOutlet weak var selectImg3: UIImageView!
    @IBOutlet weak var selectImg2: UIImageView!
    @IBOutlet weak var selectedImg1: UIImageView!
    
    @IBOutlet weak var btnTendorOutlet: UIButton!
    @IBOutlet weak var btnMessageOutlet: UIButton!
    @IBOutlet weak var btnOfferOutlet: UIButton!
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    @IBOutlet weak var lblPric: UILabel!
    @IBOutlet weak var lblSubmitDate: UILabel!
    @IBOutlet weak var selectOfferView: UIView!
    @IBOutlet weak var selectOfferTextView: UITextView!
    
    
    var companyName : String?
    var id : String?
    var tendorPrice : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.offerDetailsTable.delegate = self
        self.offerDetailsTable.dataSource = self
        self.offerDetailsTable.register(UINib(nibName: "TendorCell", bundle: Bundle.main), forCellReuseIdentifier: "TendorCell")
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        self.selectedImg1.isHidden = false
        self.selectImg2.isHidden = true
        self.selectImg3.isHidden = true
        
        self.meesageTableView.delegate = self
        self.meesageTableView.dataSource = self
        self.meesageTableView.register(UINib(nibName: "SenderCellT", bundle: Bundle.main), forCellReuseIdentifier: "SenderCellT")
        self.meesageTableView.register(UINib(nibName: "ReciverCell", bundle: Bundle.main), forCellReuseIdentifier: "ReciverCell")
        
        arrName = ["Company Name", "Description", "Completion", "Submitted On", "Tendor Amount", "Attachement"]
        headerView.lblHeaderTitle.text = "Offers"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        headerView.homeDelegate = self
        meesageTableView.isHidden = true
        offerDetailsTable.isHidden = false
        self.selectOfferView.isHidden = true
        selectOfferTextView.text = "Please enter message"
        selectOfferTextView.delegate = self
        initializeViewModel()
        getOfferDetails()
        
        DashboardinitializeViewModel()
        TendorDetails()
        messageinitializeViewModel()
    }
    
    func getMessageListDetails(){
        let obj = MessageDetailsParam()
        obj.action = "message-list"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = id
        messageviewModel.getMessageDetailsToAPIService(user: obj)
    }
    func messageinitializeViewModel() {
    
    messageviewModel.showAlertClosure = {[weak self]() in
        DispatchQueue.main.async {
            if let message = self?.messageviewModel.alertMessage {
                self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
            }
        }
    }
    
    messageviewModel.updateLoadingStatus = {[weak self]() in
        DispatchQueue.main.async {
            
            let isLoading = self?.messageviewModel.isLoading ?? false
            if isLoading {
                self?.addLoaderView()
            } else {
                self?.removeLoaderView()
            }
        }
    }
    
    messageviewModel.refreshViewClosure = {[weak self]() in
        DispatchQueue.main.async {
            if self?.messageviewModel.MessageDetails.messageDetailsList != nil {
                self!.messageDetails = (self?.messageviewModel.MessageDetails.messageDetailsList)!
                if self!.messageDetails!.count > 0 {
                    self!.meesageTableView.reloadData()
                }
            }
        }
    }
}
    
    func DashboardinitializeViewModel() {
        
        DashboardviewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.DashboardviewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        DashboardviewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.DashboardviewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        DashboardviewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                self!.tendorDetails = (self?.DashboardviewModel.tendorDetails)!
                self!.offerDetailsTable.reloadData()
                self!.offerDetailsTable.isHidden = false
            }
        }
    }
    
    func TendorDetails(){
        let obj = TendorDetailsParam()
        obj.action = "tendor-details"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = "641972500"
        DashboardviewModel.getTendorDetailsToAPIService(user: obj)
    }
    
    func getOfferDetails(){
        let obj = OfferParam()
        obj.action = "view-offer-detail"
        obj.id = id
        viewModel.getOfferDetailsToAPIService(user: obj)
    }
    
    func postSelectOfferDetails(){
        let obj = SelectOfferParam()
        obj.action = "select_supplier"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = "431"
        obj.message = selectOfferTextView.text
        obj.supplier_id = offerDetailsModel.user_id
        obj.bid_id = id
        viewModel.postSelectOfferToAPIService(user: obj)
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
                if self?.viewModel.offerDetailsModel.id != nil {
                    self?.offerDetailsModel = (self?.viewModel.offerDetailsModel)!
                    self!.lblCompanyName.text = self?.companyName
                    self!.lblDays.text = (self?.viewModel.offerDetailsModel.completion_days)!
                    if let price = self?.viewModel.offerDetailsModel.amount {
                        self!.lblPric.text = "USD "  + price
                        self!.tendorPrice = "USD "  + price
                    }
                    
                    if let date = self?.viewModel.offerDetailsModel.date {
                        let completionDate = self!.dateFormator(value: date)
                        self!.lblSubmitDate.text = "Submit Date : "  + completionDate
                    }
                }
                self!.offerDetailsTable.reloadData()
                //self!.categoryCollectionview.reloadData()
            }
        }
        viewModel.refreshSelectOfferViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self?.viewModel.additionalInfoModel.message != nil {
                    self!.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.additionalInfoModel.message)!, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
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
    
    @IBAction func tendorDetailsBtnAction(_ sender: Any) {
        self.selectedImg1.isHidden = false
        self.selectImg2.isHidden = true
        self.selectImg3.isHidden = true
        
        self.btnTendorOutlet.setTitleColor(UIColor(red: 74/255, green: 176/255, blue: 177/255, alpha: 1.0), for: .normal)
       
        self.btnMessageOutlet.setTitleColor(.black, for: .normal)
        self.btnOfferOutlet.setTitleColor(.black, for: .normal)
        meesageTableView.isHidden = true
        offerDetailsTable.isHidden = false
        self.selectOfferView.isHidden = true
    }
    
    @IBAction func MessageBtnAction(_ sender: Any) {
        getMessageListDetails()
        self.selectedImg1.isHidden = true
        self.selectImg2.isHidden = false
        self.selectImg3.isHidden = true
        meesageTableView.isHidden = false
        offerDetailsTable.isHidden = true
        self.btnTendorOutlet.setTitleColor(.black, for: .normal)
        self.btnOfferOutlet.setTitleColor(.black, for: .normal)
        self.btnMessageOutlet.setTitleColor(UIColor(red: 74/255, green: 176/255, blue: 177/255, alpha: 1.0), for: .normal)
        self.selectOfferView.isHidden = true
    }
    
    @IBAction func offerListBtnAction(_ sender: Any) {
        self.selectedImg1.isHidden = true
        self.selectImg2.isHidden = true
        self.selectImg3.isHidden = false
        
        self.btnOfferOutlet.setTitleColor(UIColor(red: 74/255, green: 176/255, blue: 177/255, alpha: 1.0), for: .normal)
        self.btnTendorOutlet.setTitleColor(.black, for: .normal)
        self.btnMessageOutlet.setTitleColor(.black, for: .normal)
        
        meesageTableView.isHidden = true
        offerDetailsTable.isHidden = true
        self.selectOfferView.isHidden = false
    }
    
    @IBAction func selectOfferSubmitBtnAction(_ sender: Any) {
        if selectOfferTextView.text == "Please enter message" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter message", okButtonText: okText, completion: nil)
        }else{
            postSelectOfferDetails()
        }
    }
    
    
    func homeMneu() {
        
    }
}

extension OfferDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == meesageTableView {
            if messageDetails != nil && messageDetails!.count > 0 {
                return messageDetails!.count
            }else{
                return 0
            }
        }else{
            return arrName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == meesageTableView {
            let senderId = messageDetails![indexPath.row].sender
            if senderId == AppPreferenceService.getString(PreferencesKeys.userID) {
                let receiverCell = tableView.dequeueReusableCell(withIdentifier: "ReciverCell") as! ReciverCell
                receiverCell.intializeCellDetails(cellDic: messageDetails![indexPath.row])
                return receiverCell
            }else{
                let senderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCellT") as! SenderCellT
                senderCell.intializeCellDetails(cellDic: messageDetails![indexPath.row])
                return senderCell
            }
        }else{
            let Cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailsCell") as! OfferDetailsCell
            Cell.lblName.text = arrName[indexPath.row]
            switch indexPath.row {
            case 0:
                Cell.lblValues.text = tendorDetails.company ?? ""
            case 1:
                Cell.lblValues.text = tendorDetails.tender_description ?? ""
            case 2:
                Cell.lblValues.text = tendorDetails.exp_date ?? ""
            case 3:
                Cell.lblValues.text = tendorDetails.opening_date ?? ""
            case 4:
                Cell.lblValues.text = tendorPrice ?? ""
            case 5:
                Cell.lblValues.text = tendorDetails.attachment ?? "N/A"
            default:
                return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            }
            return Cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == meesageTableView {
            if messageDetails![indexPath.row].message!.count > 50 {
                return UITableView.automaticDimension
            }else{
                return 65
            }
        }else{
            return 55
        }
    }
}

extension OfferDetailsVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if selectOfferTextView.text == "Please enter message" {
            selectOfferTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
