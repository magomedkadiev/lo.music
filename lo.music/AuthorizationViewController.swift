//
//  AuthorizationViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK

/**
 The authorization view controller scene. Started scene.
 */
class AuthorizationViewController: UIViewController {
 
    /// The enter button.
    @IBOutlet weak var enterButton: UIButton!
    
    /// The vkDelegate reference.
    var vkReference : VKDelegate?
    
    // MARK: - Actions
    
    /**
     The enter button action. Calls when user taps to `enterButton`.
     */
    @IBAction func enterAction(_ sender: Any) {
        VK.logOut()
        VK.logIn()
        User.isRegistered = true
    }
}



