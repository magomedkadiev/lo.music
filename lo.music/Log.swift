//
//  Log.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 15/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit

/**
 The `Log` is an utility for logging text messages.
 */
class Log {
    
    // MARK: - Initialization
    
    /// :nodoc:
    private init() {}
    
    // MARK: - Logging

    /**
     Adds a message with the specified type to the log.
     
     - parameter message: The message text.
     - parameter type: The message type.
     */
    static func addMessage(message: String, type: LogMessageType) {
        print("[\(String(describing: type))] \(message)")
    }
}
