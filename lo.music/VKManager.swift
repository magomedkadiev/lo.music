//
//  VKManager.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 28/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import SwiftyVK
import UIKit

/**
 VKManager class contains all delegate's methods.
 */
class VKManager: VKDelegate {
    
    // MARK: - Parameters
    
    /// The app iD.
    let appID = "5728731"
    
    /// The singleton `VKManager` instance.
    static let shared = VKManager()
    
    /// The array of parametres that user allows when authorized the app.
    let scope: Set <VK.Scope> = [.offline, .audio]
    
    // MARK: - Initialization
    
    /**
     Initialize library with identifier and application delegate.
    */
    init() {
        VK.configure(withAppId: appID, delegate: self)
    }
    
    // MARK: VKDelegate
    
    /**
     Called when SwiftyVK did failed autorization.
     */
    func vkAutorizationFailedWith(error: AuthError) {
        Log.addMessage(message: "Autorization failed with error: \(error)", type: .info)
    }
    
    /**
     Called when SwiftyVK need autorization permissions.
     
     - returns: permissions as VK.Scope type.
     */
    func vkWillAuthorize() -> Set<VK.Scope> {
        Log.addMessage(message: "Will Authorize Scope: \(scope)", type: .info)
        return scope
    }
    
    /**
     Called when SwiftyVK did authorize and receive token.
     */
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        Log.addMessage(message: "access_token: \(parameters["access_token"]!)", type: .debug)
        Log.addMessage(message: "user_id: \(parameters["user_id"]!)", type: .debug)
        Log.addMessage(message: "expires_in: \(parameters["expires_in"]!)", type: .debug)

        _ = VK.API.Stats.trackVisitor([.token : parameters["access_token"]! ])
    }
    
    /**
     Called when SwiftyVK did unauthorize and remove token.
     */
    func vkDidUnauthorize() {}
    
    /**
     Called when SwiftyVK need know where a token is located.
     
     - returns: Path to save/read token or nil if should save token to UserDefaults.
     */
    func vkShouldUseTokenPath() -> String? { return nil }
    
    /**
     Called when need to display a view from SwiftyVK.
     
     - returns: UIViewController that should present autorization view controller.
     */
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}


