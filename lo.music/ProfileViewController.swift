//
//  ProfileViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK

/**
 The `ProfileViewController` is a view controller of the profile scene.
 */
class ProfileViewController: UIViewController {

    /**
     Initializes a view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    /**
     Log out button. Calls when user tap to logout.
     */
    @IBAction func logOutButton(_ sender: Any) {
        VK.logOut()
        User.isRegistered = false
        
        let storyboard = UIStoryboard(name: "Authorization", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationAuthController") as? UINavigationController
        self.present(viewController!, animated: true, completion: nil)
    }
    
    /**
     Calls when user tap to back button. Close current model view controller.
     */
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    } 
}
