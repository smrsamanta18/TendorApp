//
//  SearchResultVC.swift
//  TendorApp
//
//  Created by Samir Samanta on 22/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit

class SearchResultVC: BaseViewController ,headerMenuActionDelegate{

    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchView: RoundUIView!
    
    @IBOutlet weak var searchTableView: UITableView!
    var searchTest : String?
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    var cat_ID : String?
    var isNavigateFromCat : Bool?
    var resultList : [LatestTendorList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchView.isHidden = true
        self.searchTxtField.delegate = self
        
        headerSetup()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.register(UINib(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCell")
        // Do any additional setup after loading the view.
        
        
        headerView.homeDelegate = self
        
        self.initializeViewModel()
        if isNavigateFromCat == true {
            getTendorByCatResult()
        }else{
            self.getSearchResult()
        }
    }
    
    func getTendorByCatResult(){
        let param = SearchParam()
        param.action = "tendor-search"
        param.cat_id = cat_ID
        viewModel.getSearchResultDetailsToAPIService(user: param)
    }
    
    func getSearchResult(){
        let param = SearchParam()
        param.action = "search-result"
        param.type = "2"
        param.cat_id = ""
        param.search = searchTest
        viewModel.getSearchResultDetailsToAPIService(user: param)
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
                    
                    self!.resultList = self?.viewModel.SearchResult.resultList
    //                self!.categoryList = (self?.viewModel.CategoryDetails.categoryList)!
    //                self!.serviceList = (self?.viewModel.CategoryDetails.serviceList)!
    //                self!.productList = (self?.viewModel.CategoryDetails.productList)!
                    if self!.resultList!.count > 0 {
                        self!.searchTableView.reloadData()
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Nothing is found please try again  ", okButtonText: okText, completion: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }                    
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
        headerView.lblHeaderTitle.text = "Search Result"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgProfileIcon.image = UIImage(named:"AdvanceSearch")
        tabBarView.homeImg.image = UIImage(named: "HomeSelect")
        tabBarView.lblHome.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
    }
    
    func homeMneu(){
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeMenuVC") as? HomeMenuVC
//        self.navigationController?.pushViewController(vc!, animated: true)
        
        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "AdvanceSearchVC") as? AdvanceSearchVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        self.searchView.isHidden = false
        searchTxtField.becomeFirstResponder()
    }
    
    @IBAction func searchBtnBackAction(_ sender: Any) {
         self.searchView.isHidden = true
        searchTxtField.resignFirstResponder()
    }
}

extension SearchResultVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultList != nil && self.resultList!.count > 0 {
            return resultList!.count
        }else{
            return 0
        }
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
//        Cell.lblName.text = self.productList![indexPath.row].cat_name
        Cell.initializeCellDetails(cellDic: self.resultList![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
        vc?.tID = resultList![indexPath.row].tid
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension SearchResultVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        self.searchView.isHidden = true
        searchTest = searchTxtField.text
        getSearchResult()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
