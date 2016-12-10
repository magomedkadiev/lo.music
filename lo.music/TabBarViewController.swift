//
//  TabBarViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 10/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit


/// The main view conttoller is kind of UITabBarController.
class TabBarViewController: UITabBarController, UITabBarControllerDelegate, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    
    /// Interacted class contains parameters.
    let interactor = Interactor()
    
    // MARK: - Initialization.
    
    /// Initialize view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // MARK: - UITabBarControllerDelegate
    
    /// Asks the delegate whether the specified view controller should be made active.
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let viewController = viewController as? UINavigationController {
            if viewController.viewControllers[0] is PlayerViewController {
                let storyboard = UIStoryboard(name: "Player", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                viewController.transitioningDelegate = self
                viewController.interactor = interactor
                viewController.hidesBottomBarWhenPushed = true
                self.present(viewController, animated: true, completion: nil)
                
                return false
            }
        } else {
            return true
        }
        return true
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    /// The delete method.
    ///
    /// - Parameter dismissed: The view controller.
    /// - Returns: Object value.
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    /// An object that implements the protocol vends the objects used to manage a fixed-length or interactive transition between view controllers
    ///
    /// - Parameter animator: The animator.
    /// - Returns: Bool vaue if interactive transitiong.
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
