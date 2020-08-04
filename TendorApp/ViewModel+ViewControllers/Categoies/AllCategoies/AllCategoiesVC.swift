//
//  AllCategoiesVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 18/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class AllCategoiesVC: BaseViewController
{

    @IBOutlet var serviceCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    lazy var viewModel: HomeVM = {
        return HomeVM()
    }()
    var CategoryDetails = CategoryModel()
    var categoryList : [CategoryList]?
    var serviceList : [ServiceList]?
    var productList : [ProductList]?
    var titleArray = NSArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        productCollectionView.register(UINib(nibName: "CategoryHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderCell")
        
       // productCollectionView.register(CategoryHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeaderCell")
        
       

        
        headerSetup()
        self.addLoaderView()
        self.getDashboardDetails()
        self.initializeViewModel()
        titleArray = ["Products, Service"]
        
        
    }
    
    func getDashboardDetails(){
        let obj = dashboardParam()
        obj.action = "category"
        viewModel.getCategoryDetailsToAPIService(user: obj)
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
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
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
                
                self!.categoryList = (self?.viewModel.CategoryDetails.categoryList)!
                self!.serviceList = (self?.viewModel.CategoryDetails.serviceList)!
                self!.productList = (self?.viewModel.CategoryDetails.productList)!
                self!.productCollectionView.reloadData()
            }
        }
    }
}

extension AllCategoiesVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
            
        if section == 0 {
            if productList != nil  && self.productList!.count > 0 {
                return productList!.count
            }else{
                return 0
            }
        }else{
            if serviceList != nil  && self.serviceList!.count > 0 {
                return serviceList!.count
            }else{
                return 0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! ProductCollectionCell
        if indexPath.section == 0 {
            cell.lblName.text = productList![indexPath.row].cat_name
            if let iconURL = productList![indexPath.row].icon{
                let fullURL = APIConstants.baseURL + iconURL
                cell.imgIco.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "placeholder"))
                
            }
        }else{
            cell.lblName.text = serviceList![indexPath.row].cat_name
            if let iconURL = serviceList![indexPath.row].icon{
                let fullURL = APIConstants.baseURL + iconURL
                cell.imgIco.sd_setImage(with: URL(string: fullURL), placeholderImage: UIImage(named: "placeholder"))
                
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "ProductServiceHeaderCell",
                                                                             for: indexPath) as! ProductServiceHeaderCell
            
            if indexPath.section == 0 {
                headerView.lblAnyText.text = "Products"
            }else{
                headerView.lblAnyText.text = "Services"
            }
            
            return headerView
            
            default:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                 withReuseIdentifier: "ProductServiceHeaderCell",
                                                                                 for: indexPath) as! ProductServiceHeaderCell
                return headerView

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (collectionView.frame.width - (30 + 30))/4 //150
        let height: CGFloat = 95//160
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
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
//        vc!.headerTitle = "Tendor List"
//        self.navigationController?.pushViewController(vc!, animated: true)
        if indexPath.section == 1{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC
            vc!.isNavigateFromCat = true
            
            vc?.cat_ID = serviceList![indexPath.row].cat_id
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultVC
            vc!.isNavigateFromCat = true
            vc?.cat_ID = productList![indexPath.row].cat_id
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    //viewForSupplementaryElementOfKind
}
