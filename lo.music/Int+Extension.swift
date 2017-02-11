//
//  Int+Extension.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 12/02/2017.
//  Copyright © 2017 lo.music. All rights reserved.
//

import Foundation

/// The Int extension.
extension Int {
    
    /// Covert Int variable to times.
    var toAudioString: String {
        let minutes = self / 60
        let seconds = self - minutes * 60
        if seconds < 10 {
            return "\(minutes):0\(seconds)"
        }
        return "\(minutes):\(seconds)"
    }
}
