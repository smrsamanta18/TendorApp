//
//  HomeVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 18/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import SDWebImage

class HomeVC: BaseViewController , headerMenuActionDelegate
{
    var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryCollectionview: UICollectionView!
    
    @IBOutlet weak var searchMainView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: RoundUIView!
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    
    var CategoryDetails = CategoryModel()
    var categoryList : [CategoryList]?
    var serviceList : [ServiceList]?
    var productList : [ProductList]?
    
    var latestList : [LatestTendorList]?
    var name : String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        headerSetup()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomeCell", bundle: Bundle.main), forCellReuseIdentifier: "HomeCell")
        self.addLoaderView()
        headerView.homeDelegate = self
//        tabBarView.onClickProfileButtonAction = {() -> Void in
//            print("Okay") 
//        }
        self.searchView.isHidden = true
        self.searchTextField.delegate = self
        
        self.getDashboardDetails()
        self.initializeViewModel()
    }
    
    
    func getDashboardDetails(){
//        let obj = dashboardParam()
//        obj.action = "category"
//        viewModel.getCategoryDetailsToAPIService(user: obj)
//
        viewModel.getLatestDetailsToAPIService()
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
                
                self!.latestList = self?.viewModel.LatestTendor.latestList
//                self!.categoryList = (self?.viewModel.CategoryDetails.categoryList)!
//                self!.serviceList = (self?.viewModel.CategoryDetails.serviceList)!
//                self!.productList = (self?.viewModel.CategoryDetails.productList)!
                self!.tableView.reloadData()
                //self!.categoryCollectionview.reloadData()
            }
        }
    }
    
    @IBAction func btnViewAllTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllCategoiesVC") as? AllCategoiesVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func btnMoreTapped(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeMenuVC") as? HomeMenuVC
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
        
        headerView.lblHeaderTitle.text = "Home"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.homeDelegate = self
        tabBarView.homeImg.image = UIImage(named: "HomeSelect")
        tabBarView.lblHome.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
    }
    
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AllCategoiesVC") as? AllCategoiesVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        
        self.searchView.isHidden = false
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func searchViewBackButton(_ sender: Any) {
        self.searchView.isHidden = true
    }
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.latestList != nil && self.latestList!.count > 0 {
            return latestList!.count
        }else{
            return 0
        }        
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
//        Cell.lblName.text = self.latestList![indexPath.row].title
        Cell.initializeCellDetails(cellDic: self.latestList![indexPath.row])
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.latestList![indexPath.row].tender_description!.count) > 150 {
             return 100
        } else{
             return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
        vc?.tID = latestList![indexPath.row].tid
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        if categoryList != nil && self.categoryList!.count > 0 {
            return self.categoryList!.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CategoryCell
        cell.lblName.text = categoryList![indexPath.row].cat_name
        if let iconURL = categoryList![indexPath.row].icon{
            let fullURL = APIConstants.baseURL + iconURL
            cell.imgIcon.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "placeholder"))

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 85//(collectionView.frame.width - (20 + 20))/2 //150
        let height: CGFloat = 85//160
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }else{
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let vc = UIStoryboard.init(name: "Categories", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC
//        self.navigationController?.pushViewController(vc!, animated: true)

    }
}
extension HomeVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC
        vc!.searchTest = textField.text
        vc?.isNavigateFromCat = false
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension HomeVC : UIScrollViewDelegate {
    
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset < scrollView.contentOffset.y {
            // did move up
            searchMainView.isHidden = true
            searchViewHeight.constant = 0
        } else if self.lastContentOffset > scrollView.contentOffset.y {
            // did move down
            searchMainView.isHidden = false
            searchViewHeight.constant = 65
        } else {
            // didn't move
        }
    }
}


