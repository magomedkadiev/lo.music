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

///  The `AppDelegate` class defines the delegate object of the app.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    /// The window.
    var window: UIWindow?
    
    /// The reference of vkDelegate.
    var vkReference : VKDelegate?
    
    /// The background session handler.
    var backgroundSessionCompletionHandler: (() -> Void)?
    
    // MARK: - UIApplicationDelegate
    
    /// Contains app configuration and specifies initial storyboard: `Main` (if the  user is already registered) or `Registration` (otherwise).
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        Log.addMessage(message: "\(Realm.Configuration.defaultConfiguration.fileURL!)", type: .debug)
        
        if !User.isRegistered {
            window?.rootViewController = UIStoryboard(name: "Authorization", bundle: nil).instantiateInitialViewController()!
        }
        
        return true
    }
    
    /// Tells the delegate that events related to a URL session are waiting to be processed.
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundSessionCompletionHandler = completionHandler
    }
    
    /// Tells the delegate that the launch process is almost done and the app is almost ready to run.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        vkReference = VKManager()
        return true
    }
    
    /// Asks the delegate to open a resource specified by a URL, and provides a dictionary of launch options.
    /// Make application process for iOS 9 and higher.
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if #available(iOS 9.0, *) {
            let app = options[.sourceApplication] as? String
            VK.process(url: url, sourceApplication: app)
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        }
        return true
    }
    
}

