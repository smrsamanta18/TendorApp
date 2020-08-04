//
//  AppDelegate.swift
//  TendorApp
//
//  Created by Asif Dafadar on 18/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import Alamofire
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        AppPreferenceService.setDeviceToken("")
        registerForPushNotification(for: application)
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.shared.enable = true
        self.window?.tintColor = UIColor.green
        let loggedInStatus = AppPreferenceService.getInteger(PreferencesKeys.loggedInStatus)
        if loggedInStatus == IS_LOGGED_IN {
            self.openHomeViewController()
        } else {
            self.openSignInViewController()
        }
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    public func openSignInViewController(){
        AppPreferenceService.setInteger(IS_LOGGED_OUT, key: PreferencesKeys.loggedInStatus)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        //UIApplication.shared.statusBarView?.backgroundColor =  UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.black
        
        
    }
    
    public func openHomeViewController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        navigationController = UINavigationController.init(rootViewController: controller)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.blue
    }
    
    public static func appDelagate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func isReachable() -> Bool{
        if let isReachable = reachabilityManager?.isReachable {
            return isReachable
        }
        return false
    }
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        reachabilityManager?.startListening()
    }
}

extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppPreferenceService.setDeviceToken(fcmToken)
//        SharedStorage.sharedInstance.deviceToken = fcmToken
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    
    func registerForPushNotification(for application : UIApplication ){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
    }
    
    
    //MARK: Remote notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        print(response.notification.request.content.userInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
//        self.handleUserInfo(objDictionary: response.notification.request.content.userInfo as! Dictionary)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.callHomeTabBar()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        let aps = notification.request.content.userInfo["aps"] as! NSDictionary
        let alertMsgs = aps.value(forKey: "alert") as! NSDictionary
        let alertTitle = alertMsgs.value(forKey: "title") as! String
        print(alertTitle)
        
        if alertTitle.isEmpty == false {
            var notificationMsg: String = ""
            
            if let msg = alertMsgs["body"] {
                notificationMsg = msg as! String
            }
            
            let myalert = UIAlertController(title: alertTitle, message: notificationMsg, preferredStyle: UIAlertController.Style.alert)
            
            myalert.addAction(UIAlertAction(title: "View notification", style: .default) { (action:UIAlertAction!) in
                //            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //            let controller = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                //            self.navigationController = UINavigationController.init(rootViewController: controller)
                //            self.navigationController?.navigationBar.isTranslucent = false
                //            self.navigationController?.navigationBar.isHidden = true
                //            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                //            self.window?.rootViewController = self.navigationController
                //            self.window?.makeKeyAndVisible()
                //            let nav = self.navigationController?.navigationBar
                //            nav?.barStyle = UIBarStyle.black
                //            nav?.tintColor = UIColor.blue
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                    self.callHomeTabBar()
                }
                
            })
            myalert.addAction(UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
                print("Cancel")
            })
            AudioServicesPlayAlertSound(SystemSoundID(1002))
            self.window?.rootViewController!.present(myalert, animated: true)
        }
    }
    
    func callHomeTabBar() {
//        controller.tabBarView.onClickApplyButtonAction = {() -> Void in
            if AppPreferenceService.getString(PreferencesKeys.userToken) != nil {
                
                let vc = UIStoryboard.init(name: "Notification", bundle: Bundle.main).instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
                self.navigationController?.pushViewController(vc!, animated: false)
            }else{

                let myalert = UIAlertController(title: "Login required to view notification", message: "", preferredStyle: UIAlertController.Style.alert)
                myalert.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.openSignInViewController()
                })
                self.window?.rootViewController!.present(myalert, animated: true)
            }
//        }
    }
    
    //MARK: Handle Notifications
    func handleUserInfo(objDictionary:Dictionary< String,AnyObject>) {
        
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        print("device token: \(deviceToken.description)")
//        SharedStorage.sharedInstance.deviceToken = deviceToken.description
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
}

