//
//  BuyerDashboardVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 29/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class BuyerDashboardVC: BaseViewController , headerMenuActionDelegate
{
    @IBOutlet weak var myHealthMenuCollectionView: UICollectionView!
    var mainMenuName = NSArray()
    var mainMenuArrayImage = NSArray()
    var totalMenuName = NSArray()
    
    lazy var viewModel: DashboardVM = {
        return DashboardVM()
    }()
    var uiColorArray = [UIColor]()
    var dashboardDetails = DashboardModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiColorArray = [UIColor(red: 255/255, green: 117/255, blue: 120/255, alpha: 1.0),UIColor(red: 196/255, green: 128/255, blue: 221/255, alpha: 1.0),UIColor(red: 239/255, green: 255/255, blue: 107/255, alpha: 1.0),UIColor(red: 136/255, green: 164/255, blue: 222/255, alpha: 1.0),UIColor(red: 110/255, green: 225/255, blue: 133/255, alpha: 1.0),UIColor(red: 69/255, green: 255/255, blue: 218/255, alpha: 1.0)]
        
        self.myHealthMenuCollectionView.delegate = self
        self.myHealthMenuCollectionView.dataSource = self
        self.mainMenuName = [""," ","  ", "      " , " ", "   "]
        self.totalMenuName = ["Total Tendor","Open Tendor","Close Tendor", "Manage Tendor" , "Publish Tendor", "My Feedback"]
        self.mainMenuArrayImage = ["total-tendor","dash-open","dash-closed","dash-manage" , "dash-publish" , "dash-feedback"]
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Dashboard"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        headerView.homeDelegate = self
        tabBarView.homeImg.image = UIImage(named: "HomeSelect")
//        tabBarView.onClickProfileButtonAction = {() -> Void in
//            print("Okay")
//        }
        self.getDashboardDetails()
        self.initializeViewModel()
    }
    
    func getDashboardDetails(){
        let obj = dashboardParam()
        obj.action = "buyer-dashboard"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.getDashboardDetailsToAPIService(user: obj)
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
                self!.dashboardDetails = (self?.viewModel.dashboardDetails)!
                self!.myHealthMenuCollectionView.reloadData()
                
            }
        }
    }    
    func homeMneu() {
//        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
extension BuyerDashboardVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return 6//mainMenuName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyHealthMenuCell", for: indexPath as IndexPath) as! MyHealthMenuCell
        cell.lblMenuName.text = (mainMenuName[indexPath.row] as! String)
        cell.lblTotalTendor.text = (totalMenuName[indexPath.row] as! String)
        cell.imgMenuView.image = UIImage(named:mainMenuArrayImage[indexPath.row] as! String)
//        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2
//        {
//            cell.btnPublish.isHidden = true
//        }
        switch indexPath.row {
        case 0:
            if let tendorCount = dashboardDetails.total_tender{
                cell.lblMenuName.text = String(tendorCount)
            }
        case 1:
            if let openTendorCount = dashboardDetails.total_tender_open{
                cell.lblMenuName.text = String(openTendorCount)
            }
        case 2:
            if let closeTendorCount = dashboardDetails.total_tender_close{
                cell.lblMenuName.text = String(closeTendorCount)
            }
        default:
            break
        }
        cell.backRoundView?.backgroundColor = uiColorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = collectionView.frame.width - (20 + 20)//150
        let height: CGFloat = 75//collectionView.frame.height - (20 + 20)//160
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
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        switch indexPath.row {
        case 0:
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
//            self.navigationController?.pushViewController(vc!, animated: true)
            
            let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
            vc!.headerTitle = "My Tendor"
            self.navigationController?.pushViewController(vc!, animated: true)
            
        case 1:
            let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
            vc!.headerTitle = "Open Tendor"
            self.navigationController?.pushViewController(vc!, animated: true)
            
        case 2:
            let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
            vc!.headerTitle = "Close Tendor"
            self.navigationController?.pushViewController(vc!, animated: true)
        case 3:
//            let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "ManagetendorVC") as? ManagetendorVC
//            vc!.headerTitle = "Close Tendor"
//            self.navigationController?.pushViewController(vc!, animated: true)
            print("ok")
        case 4:
            let vc = UIStoryboard.init(name: "CreateTendor", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateTendorVC") as? CreateTendorVC
            self.navigationController?.pushViewController(vc!, animated: false)
            print("ok")
        case 5:
            let vc = UIStoryboard.init(name: "FeedBack", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
            self.navigationController?.pushViewController(vc!, animated: false)
        default:
            break
        }
    }
}


