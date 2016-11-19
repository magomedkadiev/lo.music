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
    let appID = "5728731"
    
    /// The enter button.
    @IBOutlet weak var enterButton: UIButton!
    
    /// The array of parametres that user allows when authorized the app.
    let scope = [VK_PER_EMAIL, VK_PER_WALL, VK_PER_AUDIO, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_PHOTOS, VK_PER_OFFLINE, VK_PER_GROUPS]

    // MARK: - Initialization
    
    /**
     Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVK()
    }
    
    /**
     Initialize SDK with responder for global SDK events with default api.
     */
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
    
    /**
     Called if authorization state equal authorized.
     */
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
        Log.addMessage(message: "vkSdkAccessAuthorizationFinished with result", type: .info)
        
        if result.token != nil {
            goToMainStoryboard()
        } else {
            Log.addMessage(message: " Token is empty", type: .info)
        }
    }
    
    func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        Log.addMessage(message: "vkSdkAccessTokenUpdated", type: .info)
    }
    
    // MARK: - VKSdkUIDelegate
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError) {
        Log.addMessage(message: "vkSdkNeedCaptchaEnter", type: .info)
        let viewController: VKCaptchaViewController = VKCaptchaViewController.captchaControllerWithError(captchaError)
        viewController.present(in: self.navigationController!.topViewController!)

    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        Log.addMessage(message: "vkSdkShouldPresent", type: .info)
        self.navigationController!.present(controller, animated: true, completion: nil)
    }
 
}



