//
//  SettingsViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import VKSdkFramework

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        VKSdk.forceLogout()
        let storyboard = UIStoryboard(name: "Authorization", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "NavigationAuthController") as? UINavigationController
        self.present(viewController!, animated: true, completion: nil)
    }

}
