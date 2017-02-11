//
//  User.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 29/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit

/// The current authorized user information.
class User {
    
    /// A Boolean value indicating whether the user has completed registration.
    /// *Storage:* `NSUserDefaults`.
    static var isRegistered: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "user.isRegistered")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user.isRegistered")
            Log.addMessage(message: "User.isRegistered = \(newValue)", type: .info)
        }
    }
    
    /**
     A String value indicating user token.
     
     *Storage:* `NSUserDefaults`.
     */
    static var token: String {
        get {
            return UserDefaults.standard.string(forKey: "user.token")!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user.token")
            Log.addMessage(message: "user.token = \(newValue)", type: .info)
        }
    }
    
    /**
     A String value indicating user iD.
     
     *Storage:* `NSUserDefaults`.
     */
    static var iD: String {
        get {
            return UserDefaults.standard.string(forKey: "user.ID")!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "user.ID")
            Log.addMessage(message: "user.ID = \(newValue)", type: .info)
        }
    }
}
