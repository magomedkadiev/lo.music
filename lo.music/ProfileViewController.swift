//
//  ProfileViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import VKSdkFramework

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
        VKSdk.forceLogout()
        let storyboard = UIStoryboard(name: "Authorization", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationAuthController") as? UINavigationController
        self.present(viewController!, animated: true, completion: nil)
    }

}
