//
//  AppDelegate.swift
//  MVCGEN
//
//  Created by Daniel Martinez on 23/7/18.
//  Copyright © 2018 Houlak. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import OneSignal
import Fabric
import Crashlytics
import FBSDKLoginKit
import RAMAnimatedTabBarController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let homeStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
    private let loginStoryboard = UIStoryboard(name: "Login", bundle: Bundle.main)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        // TODO: enable after setting script in build phases and appid
//        self.setupFabric()
        
        self.setupOneSignal(launchOptions)
        
        // Call the 'activate' method to log an app event for use
        // in analytics and advertising reporting.
        AppEventsLogger.activate(application)
        
        self.checkUserLoggedIn()
        
        self.setupAWS()
        
        return true
    }
    
    func setupFabric() {
        Fabric.with([Crashlytics.self])
    }
    
    func setupOneSignal(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?){
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Config.sharedInstance.oneSignalAppId(),
                                        handleNotificationReceived: {
                                            notification in
                                            
                                            if let notification = notification {
                                                self.handleNotification(notification: notification)
                                            }
                                            
                                        },
                                        handleNotificationAction: {
                                            result in
                                            
                                            if let notification = result?.notification {
                                                self.handleNotification(notification: notification)
                                            }
                                            
                                            // TODO: Set new notification icon active in profilevc
                                            if let tabController = self.window!.rootViewController as? RAMAnimatedTabBarController {
                                                tabController.setSelectIndex(from: tabController.selectedIndex, to: 3)
                                            }
                                        },
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // TODO
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        
        // Print OneSignal Player ID
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        print("OneSignal User ID = \(userID ?? "")")
    }
    
    func handleNotification(notification: OSNotification){
        // TODO set new notification badge
        
    }
    
    func checkUserLoggedIn() {
        
        if let _ = UserDefaults.standard.value(forKey: UserDefaultsConstants.userAuthTokenKey) as? String, let _ = UserDefaults.standard.value(forKey: UserDefaultsConstants.savedUserKey) as? String {
            // Token stored in NSUserDefaults. Log in user
            
            // TODO: need to check if user ha ve accepted terms & conditions
            
            let rootController = self.homeStoryboard.instantiateViewController(withIdentifier: "HomeNav")
            self.window?.rootViewController = rootController
            
        }
    }
    
    // Facebook login
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//    }

    func logout() {
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
            dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                $0.cancel()
            }
            uploadTasks.forEach {
                $0.cancel()
            }
            downloadTasks.forEach {
                $0.cancel()
            }
        }
        
        FilesManager.sharedInstance.removeAllAppLocalFiles()
        
        // Facebook logout
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        for view in self.window!.subviews {
            view.removeFromSuperview()
        }
        
        let rootController = self.loginStoryboard.instantiateViewController(withIdentifier: "LoginVC")
        self.window?.rootViewController = rootController
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }
    
    func setupAWS() {
        let _ = AWSManager.sharedInstance
    }
    
}

