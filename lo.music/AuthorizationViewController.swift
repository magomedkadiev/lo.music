//
//  AuthorizationViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import VKSdkFramework

/**
 The authorization view controller scene. Started scene.
 */
class AuthorizationViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {

    // MARK: - Properties
    
    /// The enter button.
    @IBOutlet weak var enterButton: UIButton!
    
    let appID = "5728731"
    
    let scope = [VK_PER_EMAIL, VK_PER_WALL, VK_PER_AUDIO, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_PHOTOS, VK_PER_OFFLINE, VK_PER_GROUPS]

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVK()
    }
    
    private func setupVK() {
        let sdk = VKSdk.initialize(withAppId: appID)
        sdk!.register(self)
        sdk!.uiDelegate = self
        
        VKSdk.wakeUpSession(scope) { (state: VKAuthorizationState, NSError) -> Void in
            if state == .authorized {
                Log.addMessage(message: "Authorized", type: .info)
                self.goToMainStoryboard()
            } else {
                Log.addMessage(message: "Not authorized", type: .info)
            }
        }
    }
    
    private func goToMainStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let viewController = storyboard.instantiateInitialViewController()
        self.navigationController?.present(viewController!, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    /**
     The enter button action. Calls when user taps to `enterButton`.
     */
    @IBAction func enterAction(_ sender: Any) {
        VKSdk.authorize(scope)
    }
    
    // MARK: - VKSdkDelegate
    
    func vkSdkUserAuthorizationFailed() {
        Log.addMessage(message: "vkSdkUserAuthorizationFailed", type: .info)
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        Log.addMessage(message: "vkSdkTokenHasExpired", type: .info)

    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        let token = result.token
        Log.addMessage(message: "vkSdkAccessAuthorizationFinished with result \(token)", type: .info)
        
        if token != nil {
            goToMainStoryboard()
        } else {
            Log.addMessage(message: " Token - \(token) is empty", type: .info)
        }

    }
    
    // MARK: - VKSdkUIDelegate
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError) {
        Log.addMessage(message: "vkSdkNeedCaptchaEnter", type: .info)
        let vc: VKCaptchaViewController = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc.present(in: self.navigationController!.topViewController!)

    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        Log.addMessage(message: "vkSdkShouldPresent", type: .info)

        self.navigationController!.present(controller, animated: true, completion: nil)
    }
 
}



