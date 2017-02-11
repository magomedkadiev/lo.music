//
//  DismissAnimator.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 05/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import UIKit


/// The dismiss animator class.
class DismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    /// MARK: - Properties
    
    /// The singlton.
    static let shared = DismissAnimator()
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    /// The protocol’s method provide contextual information for transition animations between view controllers.
    ///
    /// - Parameter transitionContext: The view controller context.
    /// - Returns: float time interval value.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }
    
    /// The protocol’s method provide contextual information for transition animations between view controllers.
    ///
    /// - Parameter transitionContext: The view controller context.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }
        
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        fromViewController.view.frame = finalFrame
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

