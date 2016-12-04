//
//  RequestManager.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 18/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import SwiftyVK

/**
  Contains all requset with internet.
 */
class RequestManager {
    
    // MARK: - Properties
    
    /// The singleton `RequestManager` instance.
    static let shared = RequestManager()
    
    /**
     VK request return array of audios by registered userID.
     */
    func getAudios(completionHandler: @escaping (_ error: Error?) -> Void) {
        VK.API.Audio.get().send(
            onSuccess: { response in
                var audioList = [AudioItem]()
                
                for data in response["items"] {
                    let audio = AudioItem(serverData: data.1.object as! [String : AnyObject])
                    audioList.append(audio)
                    RealmManager.shared.saveAudioFromNet(item: audio)
                }
            
                RealmManager.shared.removeLocalAudioThatNotContainsInResponse(response: audioList)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(nil)
                })
            }, onError: { error in
                DispatchQueue.main.async(execute: { () -> Void in
                    completionHandler(error)
                })
        })
    }
    
}
