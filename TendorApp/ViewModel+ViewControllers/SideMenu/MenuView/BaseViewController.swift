//
//  BaseViewController.swift
//  
//
//  Created by Admin on 21/08/18.
//  Copyright © 2018 ncrts. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    
    var vwTitleHeadr: UIView!
    var btnCart: UIButton!
    var lblCount: UILabel!
    var btnTopBack: UIButton!
    var btnShare: UIButton!
    var btnFilter: UIButton!
    var btnMenu: UIButton!
    var imgBackground: UIImageView!
    var tapGesture: UITapGestureRecognizer!
    var headerView = HeaderView()
    var tabBarView = TabBarView()
    
    var isLoginTreu : Bool = false
    var height : CGFloat?
    var footerHeight : CGFloat?
    var timer: Timer?
    var constantValue : CGFloat?
    
    var onClickHomeAction: (() -> Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelName = UIDevice.modelName
        switch modelName {
        case "Simulator iPhone 5s":
            height = 100
            footerHeight = 80
            constantValue = 15
        case "Simulator iPhone 6":
            height = 100
            footerHeight = 80
            constantValue = 15
        case "Simulator iPhone 6s":
            constantValue = 15
            footerHeight = 80
            height = 60
        case "Simulator iPhone 6 Plus":
            constantValue = 15
            footerHeight = 80
            height = 60
        case "Simulator iPhone 6s Plus":
            height = 60
            footerHeight = 80
           constantValue = 15
        case "Simulator iPhone 7":
            constantValue = 15
            height = 60
            footerHeight = 80
        case "Simulator 7 Plus":
            height = 60
            footerHeight = 80
            constantValue = 15
        case "Simulator iPhone SE":
            height = 100
            footerHeight = 80
            constantValue = 15
        case "Simulator iPhone 8":
            constantValue = 15
            height = 60
            footerHeight = 70
        case "Simulator iPhone 8 Plus":
            height = 60
            footerHeight = 70
            constantValue = 15
        case "iPhone X":
            height = 80
            footerHeight = 110
            constantValue = 30
        case "Simulator iPhone X":
            height = 80
            footerHeight = 110
            constantValue = 30
        case "Simulator iPhone XS":
            constantValue = 30
            footerHeight = 110
            height = 80
        case "iPhone XS":
            constantValue = 30
            footerHeight = 110
            height = 80
        case "Simulator iPhone XS Max":
            constantValue = 30
            footerHeight = 110
            height = 80
        case "Simulator iPhone XR":
            constantValue = 30
            footerHeight = 110
            height = 80
        default:
            height = 80
            constantValue = 15
            footerHeight = 70
        }
        headerView = HeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:height!))
        headerView.centerConstraintOutlet.constant = constantValue!
        
        tabBarView = TabBarView.init(frame: CGRect(x: 0, y: self.view.frame.size.height - footerHeight!, width: self.view.frame.size.width, height:footerHeight!))
        
        self.view.addSubview(headerView)
        self.view.addSubview(tabBarView)
        
        
        headerView.onClickSideMenuButtonAction = {() -> Void in
           self.navigationController?.popViewController(animated: true)
        }
        
        tabBarView.onClickHomeButtonAction = {() -> Void in
            
            if AppPreferenceService.getString(PreferencesKeys.userToken) != nil {
                let namevaleu = AppPreferenceService.getString(PreferencesKeys.userName)
                if namevaleu != nil {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                    self.navigationController?.pushViewController(vc!, animated: false)
                }else{
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
                    self.navigationController?.pushViewController(vc!, animated: false)
                }
            }else{
                
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.openSignInViewController()
            }
            
        }
        
        tabBarView.onClickContactButtonAction = {() -> Void in
            
            if AppPreferenceService.getString(PreferencesKeys.userToken) != nil {
                
                let vc = UIStoryboard.init(name: "Message", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessageVC") as? MessageVC
                self.navigationController?.pushViewController(vc!, animated: false)
            }else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openSignInViewController()
            }
            
        }
        
        tabBarView.onClickMonitorButtonAction = {() -> Void in
             if AppPreferenceService.getString(PreferencesKeys.userToken) != nil {
                let vc = UIStoryboard.init(name: "CreateTendor", bundle: Bundle.main).instantiateViewController(withIdentifier: "CreateTendorVC") as? CreateTendorVC
                self.navigationController?.pushViewController(vc!, animated: false)
            }else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openSignInViewController()
            }
            
            
        }
        tabBarView.onClickApplyButtonAction = {() -> Void in
            if AppPreferenceService.getString(PreferencesKeys.userToken) != nil {
                
                let vc = UIStoryboard.init(name: "Notification", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
                self.navigationController?.pushViewController(vc!, animated: false)
            }else{
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.openSignInViewController()
            }
            
        }
        tabBarView.onClickProfileButtonAction = {() -> Void in
            
           let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
           self.navigationController?.pushViewController(vc!, animated: false)
            
//            let vc = UIStoryboard.init(name: "FeedBack", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedBackVC") as? FeedBackVC
//            self.navigationController?.pushViewController(vc!, animated: false)
            
            
            
        }
        headerView.onClickProfileButtonAction = {() -> Void in
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
