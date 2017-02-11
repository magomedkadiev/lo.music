//
//  AppDelegate.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK
import RealmSwift

/**
 The `AppDelegate` class defines the delegate object of the app.
 */
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    /// The window.
    var window: UIWindow?
    
    /// The vkDelegate reference.
    var vkReference : VKDelegate?
    
    /// The background session.
    var backgroundSessionCompletionHandler: (() -> Void)?

    
    // MARK: - UIApplicationDelegate

    /**
     Contains app configuration and specifies initial storyboard: `Main` (if the  user is already registered) or `Registration` (otherwise).
     */
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        Log.addMessage(message: "\(Realm.Configuration.defaultConfiguration.fileURL!)", type: .debug)

        if !User.isRegistered {
            window?.rootViewController = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()!
        }
        
        return true
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        vkReference = VKManager()        
        return true
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
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /**
     Make application process for iOS 9 and higher.
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if #available(iOS 9.0, *) {
            let app = options[.sourceApplication] as? String
            VK.process(url: url, sourceApplication: app)
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        }
        return true
    }

}

