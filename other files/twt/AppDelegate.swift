//
//  AppDelegate.swift
//  TheWeedTube
//
//  Created by Sagar Moradia on 04/02/19.
//  Copyright © 2019 Sagar Moradia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import Photos
import AVFoundation
import SideMenu
import NotificationBannerSwift
import MoPub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, NotificationBannerDelegate {
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {

    }
    
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        GLOBAL.sharedInstance.isFromNotification = false
    }

    var window: UIWindow?
    var strDeviceFCMToken : String = ""
    var strDeviceIdentifier : String = ""

    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        self.fetchDataFromJson()
        
        self.setUpNotification(application: application)
        
        Fabric.sharedSDK().debug = true
        Fabric.with([Crashlytics.self])
        
//        for familyName in UIFont.familyNames {
//            for fontName in UIFont.fontNames(forFamilyName: familyName ) {
//                print("\(familyName) : \(fontName)")
//            }
//        }
        
        print("JWPlayer SDK version: ",JWPlayerController.sdkVersion())
        JWPlayerController.setPlayerKey("1c8Ro5EVMEPfyITXQB9JbnJT5Cr0qrSmPQGXMJyL55BRZfzT")
        
        self.adSetup()
        
          DefaultValue.shared.setBoolValue(value: true, key: KEYS_USERDEFAULTS.IS_AGE_VERIFIED)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("*****----- applicationWillResignActive -----*****")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("*****----- applicationWillEnterForeground -----*****")
        if GLOBAL.sharedInstance.isAdTapped {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_NAME.On_Add_Clicked), object: nil, userInfo: nil)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        cameraAllowsAccessToApplicationCheck()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UserDefaults.standard.set(Cons_App_Killed, forKey: KEYS_USERDEFAULTS.ISAPPKILLED)
        //self.setUserDefault(Cons_App_Killed, KeyToSave: KEYS_USERDEFAULTS.ISAPPKILLED)
        
//        let videoDetailVC = UIStoryboard.init(name:"Tabbar", bundle: nil).instantiateViewController(withIdentifier: "VideoDetailVC") as! VideoDetailVC
//        videoDetailVC.jwPlayer.pause()
    }

    //MARK:- Ad Setup
    func adSetup(){
        //MPAdConversionTracker.shared().reportApplicationOpen(forApplicationID: Const_Mopub_ApplicationID)
        let sdkConfig = MPMoPubConfiguration(adUnitIdForAppInitialization: MOPUP_AD.HOME_TOP)
        sdkConfig.globalMediationSettings = []
        //sdkConfig.loggingLevel = MPLogLevel.info
        MoPub.sharedInstance().initializeSdk(with: sdkConfig) {
            print("SDK initialization complete")
        }
    }
    
    //MARK:- Orientation
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    //MARK:- Set Notifications
    func setUpNotification(application:UIApplication){
        self.getFCMToken()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self as? MessagingDelegate
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                DispatchQueue.main.async {
                    self.getFCMToken()
                }
            }
            application.registerForRemoteNotifications()
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
    }
    
    //MARK:- JSON Parsing for themes
    func fetchDataFromJson(){

        let url = Bundle.main.url(forResource: Theme_File_Name, withExtension: Theme_File_Type)!
        do {
            let data = try Data(contentsOf: url)
            let themeModel = try? JSONDecoder().decode(ThemesModel.self, from: data)
            let arrThemes = themeModel?.data
            GLOBAL.sharedInstance.arrThemes = [Themes]()
            GLOBAL.sharedInstance.arrThemes = arrThemes!
        } catch {
            print(error)
        }
        
        GLOBAL.sharedInstance.strSelectedThemeID = "1"
        GLOBAL.sharedInstance.strSelectedThemeName = "Light"
    }
 
    //MARK: - FCM Notification Delegate Methods
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        Messaging.messaging().apnsToken = deviceToken
        
        if (Messaging.messaging().fcmToken != nil) {
            strDeviceFCMToken = Messaging.messaging().fcmToken!
            if strDeviceFCMToken != ""{
                UserDefaults.standard.set(strDeviceFCMToken, forKey: KEYS_USERDEFAULTS.DEVICE_TOKEN)
                print("\n------------FCM token---------\n",strDeviceFCMToken)
            }else{
                let fcmToken = Messaging.messaging().fcmToken
                if fcmToken != nil || fcmToken != ""{
                    UserDefaults.standard.set(strDeviceFCMToken, forKey: KEYS_USERDEFAULTS.DEVICE_TOKEN)
                    print("\n------------FCM token---------\n",fcmToken!)
                }else{
                    UserDefaults.standard.set(strDeviceFCMToken, forKey: KEYS_USERDEFAULTS.DEVICE_TOKEN)
                }
            }
        }
        else{
            UserDefaults.standard.set(strDeviceFCMToken, forKey: KEYS_USERDEFAULTS.DEVICE_TOKEN)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo as! [String: Any]
        
        print(userInfo)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo.description)
        
        /*Temporary testing push notification remove it when go live
        GLOBAL.sharedInstance.isFromNotification = true
        GLOBAL.sharedInstance.Notification_uuid = "d1d0147a-555c-11e9-8930-000c29f57809"
        GLOBAL.sharedInstance.Notification_type = "video"
        GLOBAL.sharedInstance.Notification_count = "1"
        self.showCustomBannerForNotificationWhenAppInActiveMode(title: "Test", subtitle: "Push notification")
        */
        
        
        /*
         
        let alertController = UIAlertController(title: APPLICATION.applicationName, message: userInfo.description, preferredStyle: .alert)
        
        let viewAction = UIAlertAction(title: Cons_Btn_View, style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        }
        let cancelAction = UIAlertAction(title: Cons_Cancel, style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(viewAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        */
        
        
        if userInfo["gcm.notification.customParam"] != nil{
            
            completionHandler(UIBackgroundFetchResult.newData)
            
            guard let jsonString = userInfo["gcm.notification.customParam"] as? String else{
                return
            }
            
            let strCustomParamData: Data? = jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            var jsonOutput: Any? = nil
            if let aData = strCustomParamData {
                jsonOutput = try? JSONSerialization.jsonObject(with: aData, options: [])
            }
            
            guard let dictActionType = jsonOutput as? NSDictionary, let notification_type = dictActionType.value(forKey:"type") as? String else{
                return
            }
            
            guard let dictActionUuid = jsonOutput as? NSDictionary, let notification_uuid = dictActionUuid.value(forKey:"uuid") as? String else{
                return
            }
            
            
            let notification_unread_count = dictActionUuid.value(forKey:"unreadCount") as? String ?? "1"
            
//            guard let dictCount = jsonOutput as? NSDictionary, let notification_unread_count = dictCount.value(forKey:"unreadCount") as? String else{
//                return
//            }
            
            guard let dictNoti_uuid = jsonOutput as? NSDictionary, let noti_uuid = dictNoti_uuid.value(forKey:"notification_uuid") as? String else{
                return
            }
            
            let aps = userInfo["aps"] as! NSDictionary
            let alert = aps["alert"] as! NSDictionary
            let title = alert["title"] as? String ?? ""
            let body = alert["body"] as? String ?? ""
            print(title)
            print(body)
            
            if UIApplication.shared.applicationState == UIApplication.State.active {
                print("------Application in Active state---------")
                if notification_uuid != ""{
                    GLOBAL.sharedInstance.isFromNotification = true
                    GLOBAL.sharedInstance.Notification_uuid  = notification_uuid
                    GLOBAL.sharedInstance.Notification_type  = notification_type
                    GLOBAL.sharedInstance.Notification_count = notification_unread_count
                    GLOBAL.sharedInstance.N_ID               = noti_uuid
                    
                    self.showCustomBannerForNotificationWhenAppInActiveMode(title: title, subtitle: body)
                }
            }
            else if UIApplication.shared.applicationState == UIApplication.State.inactive || UIApplication.shared.applicationState == UIApplication.State.background{
                print("------Application in Inactive state or Background state---------")
                GLOBAL.sharedInstance.isFromNotification = true
                GLOBAL.sharedInstance.Notification_uuid  = notification_uuid
                GLOBAL.sharedInstance.Notification_type  = notification_type
                GLOBAL.sharedInstance.Notification_count = notification_unread_count
                GLOBAL.sharedInstance.N_ID               = noti_uuid
                self.notificationRedirection()
            }
        }
    }
    /* Custome baner when app in active state */
    func showCustomBannerForNotificationWhenAppInActiveMode(title: String, subtitle: String)  {
        
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: .success)
        
        banner.delegate = self

        
        banner.onTap = {
            GLOBAL.sharedInstance.isFromNotification = true
            self.notificationRedirection()
        }
        banner.onSwipeUp = {
            banner.dismiss()
        }
        
       
        banner.backgroundColor = UIColor.init(red: 0, green: 84, blue: 42) // set baner color here
        banner.subtitleLabel?.textAlignment = .left
        banner.show()
    }
    
    //MARK:- Redirect for Notification
    func showAlertForNotification(msg:String){
        
        //let msg = n_msg + " " + GLOBAL.sharedInstance.Notification_type
        let alertController = UIAlertController(title: APPLICATION.applicationName, message: msg, preferredStyle: .alert)
        
        let viewAction = UIAlertAction(title: Cons_Btn_View, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.notificationRedirection()
        }
        let cancelAction = UIAlertAction(title: Cons_Cancel, style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(viewAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func notificationRedirection(){
        
        if self.getUserDefault(KEYS_USERDEFAULTS.AUTHORIZATION) != nil{
            self.redirectToHomeScreen()
        }
        
    }
    
    @objc func redirectToHomeScreen() {
        
        let sideDrawer = UIStoryboard.init(name: ("SideDrawer"), bundle: nil).instantiateViewController(withIdentifier: "SideDrawerMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = sideDrawer
        
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.dark
        SideMenuManager.default.menuWidth = SCREEN_WIDTH * RATIO
        SideMenuManager.default.menuShadowOpacity = 0.6
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.0
        let objHome = UIStoryboard.init(name: ("Tabbar"), bundle: nil).instantiateViewController(withIdentifier: "Tabbar_Main")
        APPLICATION.appDelegate.window?.rootViewController = objHome
    }
    
    //MARK:- CAMERA ACCESS CHECK
    func videoAllowsAccessToApplicationCheck()
    {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                print("access granted")
                                            }
                                            else {
                                                print("access denied")
                                            }
            })
        case .authorized:
            print("Access authorized")
        case .denied, .restricted:
            print("Denied access")
        default:
            print("DO NOTHING")
        }
    }
    
    func cameraAllowsAccessToApplicationCheck()
    {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch authorizationStatus {
        case .notDetermined:
            // permission dialog not yet presented, request authorization
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("access granted")
                }else{
                    print("access denied")
                }
            })
        case .authorized:
            print("Access authorized")
        case .denied, .restricted:
            print("Denied access")
        default:
            print("DO NOTHING")
        }
    }
}

extension AppDelegate{
    //MARK:- Get FCM Token
    fileprivate func getFCMToken() {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if error == nil {
                print("FCM Token HS: \(result!.token)")
                UserDefaults.standard.set(result!.token, forKey: KEYS_USERDEFAULTS.DEVICE_TOKEN)
            }
        })
    }
    
}

