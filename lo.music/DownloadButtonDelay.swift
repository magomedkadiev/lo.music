//
//  DownloadButtonDelay.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 06/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation


/// The download button delay.
public class DownloadButtonDelay {
    
    // MARK: - Propetries
    
    /// The previous delay value.
    private var previousDelay: DownloadButtonDelay?
    
    /// The then delay value.
    private var thenDelay: DownloadButtonDelay?
    
    /// The void.
    private var action: () -> Void
    
    /// The time interval.
    private var interval: TimeInterval = 0
    
    // MARK: - Initialization
    
    /// Initializa current class.
    ///
    /// - Parameters:
    ///   - interval: Used to specify a time interval, in seconds.
    ///   - action: Void.
    init(interval: TimeInterval, action: @escaping () -> Void) {
        self.interval = interval
        self.action = action
    }
    
    
    /// The method.
    ///
    /// - Parameter thenDelay: The download button delay
    /// - Returns: The download button delay with setted parameters.
    func then(_ thenDelay: DownloadButtonDelay) -> DownloadButtonDelay {
        self.thenDelay = thenDelay
        thenDelay.previousDelay = self
        return thenDelay
    }
    
    /// Start delay.
    private func start() {
        delay(aDelay: self.interval, closure: {
            self.action()
            self.thenDelay?.start()
        })
    }
    
    /// Run delay.
    func run() {
        if self.previousDelay != nil {
            var starter = self.previousDelay!
            while starter.previousDelay != nil {
                starter = starter.previousDelay!
            }
            starter.start()
        } else {
            self.start()
        }
    }
    
    
    /// The delay func.
    ///
    /// - Parameters:
    ///   - aDelay: Used to specify a time interval, in seconds.
    ///   - closure: The void.
    public func delay(aDelay:TimeInterval, closure: @escaping () -> Void) {
        delay(aDelay: aDelay, queue: DispatchQueue.main, closure: closure)
        
    }
    
    /// The delay func.
    ///
    /// - Parameters:
    ///   - aDelay: Used to specify a time interval, in seconds.
    ///   - queue: DispatchQueue manages the execution of work items.
    ///   - closure: The void.
    public func delay(aDelay: TimeInterval, queue: DispatchQueue!, closure: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + aDelay
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
    } 
}
