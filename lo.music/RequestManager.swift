//
//  RequestManager.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 18/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import VKSdkFramework

/**
  Contains all requset with internet.
 */
class RequestManager {
    
    // MARK: - Properties
    
    /// The singleton `RequestManager` instance.
    static let shared = RequestManager()
    
    /// The access token from VKSdk.
    let accessToken = VKSdk.accessToken()
    
    /**
     VK request return array of audios by registered userID.
     */
    func getAudio(success: @escaping (_ serverData: [AnyObject]) -> Void) {
        let request = VKRequest(method: "audio.get", parameters: [VK_API_OWNER_ID: accessToken!.userId])
    
        request?.execute( resultBlock: { (response) -> Void in
            Log.addMessage(message: "Get audio succsess: \(response!.json)", type: .debug)
            
            let dataDict = response?.json as! [String : AnyObject]
            if let serverData = dataDict["items"] as? [AnyObject] {
                success(serverData)
            }
            
        }, errorBlock: { (error) -> Void in
            Log.addMessage(message: "Get audio failed: \(error!.localizedDescription)", type: .debug)
        })
    }
}
