//
//  PlayerViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 05/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit


/// The plaer view controller scene.
class PlayerViewController: UIViewController {

    // MARK: - Properties
    
    /// Interacted class contains parameters.
    var interactor: Interactor?
    
    // MARK: - Initialization
    
    /// Initialazie view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /// Calls when user tapped to hide controller button.
    ///
    /// - Parameter sender: UIBarButtonItem.
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Call when user drag a view controller.
    ///
    /// - Parameter sender: UIPanGestureRecognizer.
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.1
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    } 
}
