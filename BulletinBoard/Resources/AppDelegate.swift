//
//  AppDelegate.swift
//  BulletinBoard
//
//  Created by Dustin Koch on 6/3/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (userResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if userResponse {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        MessageController.sharedInstance.subscribeToNotifications { (error) in
            if let error  = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        MessageController.sharedInstance.fetchMessages { (success) in
            if success {
                print("Messages fetched after receiving remote notifications")
            }
        }
    }

}

