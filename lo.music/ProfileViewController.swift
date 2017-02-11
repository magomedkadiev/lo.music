//
//  ProfileViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK
import RealmSwift

/**
 The `ProfileViewController` is a view controller of the profile scene.
 */
class ProfileViewController: UIViewController {

    // MARK: - Properties
    
    /// The count label.
    @IBOutlet weak var countLabel: UILabel!
    
    /// The size label.
    @IBOutlet weak var sizeLabel: UILabel!
    
    /// Set status bar style.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /**
     Initializes a view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let realm = try! Realm()
        let count: Double = realm.objects(SavedAudio.self).sum(ofProperty: "size")
        let countSavedAudios = realm.objects(SavedAudio.self).count
        
        countLabel.text = "\(countSavedAudios) песни в избранном"
        sizeLabel.text = "\(count) MB из 2.0 GB"
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
