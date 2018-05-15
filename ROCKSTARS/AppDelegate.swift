//
//  AppDelegate.swift
//  ROCKSTARS
//
//  Created by Rakesh Kumar on 5/2/17.
//  Copyright © 2017 SoftProdigy. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import BRYXBanner

import GoogleMaps
import GooglePlaces
import UserNotifications
import Fabric
import Crashlytics
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    //MARK: - Variables
    
    var window: UIWindow?
    var btn1_user : UIButton?
    var btn2_user : UIButton?
    var btn3_user : UIButton?
    var badgeCount = 0
    var ratingViewController:RatingViewController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
         UserDefaults.standard.set(false, forKey: "IsDirectProfile")
        UIApplication.shared.applicationIconBadgeNumber = 0
        registerForRemoteNotification()
        IQKeyboardManager.sharedManager().enable = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if(UserDefaults.standard.bool(forKey: "IsLogin") == true)
        {
            ReadNotifications()
            if(UserDefaults.standard.value(forKey: Krole_type) as! String == "2")
            {
                UIApplication.shared.isStatusBarHidden = false
                InitilizeUserHome()
            }
            else
            {
                UIApplication.shared.isStatusBarHidden = false
                InitilizeVenueHome()
            }
        }
        else
        {
            InitilizeLogin()
        }
      //  GMSPlacesClient.provideAPIKey("AIzaSyAkB27vm8v1Oi-f7HXhudvyx-4CGxk9Az0")
      //  GMSServices.provideAPIKey("AIzaSyAkB27vm8v1Oi-f7HXhudvyx-4CGxk9Az0")
          GMSPlacesClient.provideAPIKey("AIzaSyAOlENNTvX2XBF_BMMngudph5n44xPLarE")
          GMSServices.provideAPIKey("AIzaSyAXK23fFFFZE9K1OkUfzcoRwg3fpz5hwUk")
      //  AIzaSyAOlENNTvX2XBF_BMMngudph5n44xPLarE
        Fabric.with([Crashlytics.self])
        sleep(UInt32(3.0))
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func InitilizeLogin()
    {
        IQKeyboardManager.sharedManager().enable = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigation")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    func InitilizeUserHome()
    {
        IQKeyboardManager.sharedManager().enable = true
        let storyboard = UIStoryboard(name: "Dashboard_User", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "UserNaviagtion") as! UINavigationController
        initialViewController.navigationBar.isHidden = true
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
    }
    func InitilizeVenueHome()
    {
        IQKeyboardManager.sharedManager().enable = true
        let storyboard = UIStoryboard(name: "Dashboard_Venue", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "VenueNavigation") as! UINavigationController
        initialViewController.navigationBar.isHidden = true
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        return isHandled
        
    }
    
    //MARK: - Notification delegate
    
    func registerForRemoteNotification()
    {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        else
        {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // Called when APNs has assigned the device a unique token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        defaults.set(deviceTokenString, forKey: Kdevice_token)
        print("APNs device token: \(deviceTokenString)")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        let deviceTokenString = "etgfjklonbghtdgetryhjklfbdxvasexcdbhjmnb"
        defaults.set(deviceTokenString, forKey: "device_token")
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
        completionHandler(UIBackgroundFetchResult.noData)
        
        let aps = userInfo[AnyHashable(Kaps)] as? NSDictionary
        let data = userInfo[AnyHashable(KextraPayLoad)] as? NSDictionary
        let alert = aps?[Kalert] as? NSDictionary
        let label = aps?[Klabel] as? String
        let body = alert?[Kbody] as? String
        let title = alert?[Ktitle] as? String
        
        print("Title: \(title) \nBody:\(body)")
        print(aps ?? "")
        print(data ?? "")
        print(alert ?? "")
        print(userInfo )
        
        let banner = Banner(title: body, subtitle: "", image: UIImage(named: "Icon"), backgroundColor: UIColor(red:101.00/255.0, green:23.0/255.0, blue:101.5/255.0, alpha:1.000))
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
        
        if(label == Kcomplete)
        {
            AddRatingView(dic: data as! [String:Any])
        }
    }
    
    func AddRatingView(dic : [String: Any])
    {
        ratingViewController?.view.removeFromSuperview()
        let storyboard = UIStoryboard(name: KMain, bundle: nil)
        ratingViewController = storyboard.instantiateViewController(withIdentifier: KRatingViewController) as? RatingViewController
        ratingViewController?.DataDic = dic as [String:Any]
        self.window?.addSubview((ratingViewController?.view)!)
        self.window?.makeKeyAndVisible()
    }
    
    func RemoveRatingView()
    {
        ratingViewController?.view.removeFromSuperview()
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //MARK:- Profile API
        
        //  MBProgressHUD.showAdded(to: self.view, animated: true)
        if(UserDefaults.standard.bool(forKey: "IsLogin") == true)
        {

        ReadNotifications()
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        
        //  UIApplication.shared.applicationIconBadgeNumber = badgeCount
        //badgeCount =  badgeCount + 1
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Read Notifications
    
    func ReadNotifications()
    {
        if Reach.isConnectedToNetwork() == true
        {
       
        let param : [String:String] = [KuserID:UserDefaults.standard.value(forKey: KuserID) as! String]
     //   print(param)
        let url = kBaseUrl + KreadNotification
            
                Alamofire.request(url, method : .post, parameters : param).responseJSON(completionHandler: {
                    response in
                    print(response.result)
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                      //  let responseJson = JSON as! [String: Any]
                        if response.response?.statusCode == 200 {
                            
                          //  self.delegate?.Response(Resposnedic: responseJson)
                        }
					/******************************///Aman
						else  if response.response?.statusCode == 401
						{
								let msg: String = "Your account has been temporarily blocked by admin. Please contact to admin."
								CommonFunctions.sharedInstance.showAlert(message: msg, delegate: self)
							//  self.delegate?.Response(Resposnedic: responseJson)
						}
					/***********************/
                        else{
                           // self.delegate?.Failure()
                        }
                    } else {
                      //  self.delegate?.Failure()
                    }
                }) }

        
    }
    
    
}

