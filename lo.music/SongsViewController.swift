//
//  SongsViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 16/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import VKSdkFramework

class SongsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getAudio() {
        let request = VKRequest(method: "audio.get", parameters: [VK_API_OWNER_ID: 125572463, VK_API_COUNT: "10"])

        request?.execute( resultBlock: {
                (response) -> Void in
                print(response!.json)
            
        }, errorBlock: { (error) -> Void in
            print("error")
        })
    }

}
