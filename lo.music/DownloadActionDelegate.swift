//
//  DownloadActionDelegate.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 03/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation

/// Download action delegate. Contain methods for start and stop download audio.
protocol DownloadActionDelegate {
    
    /// Stop download tapped. Calls when user stop downloading.
    ///
    /// - Parameter cell: The audio cell.
    func stopDownloadTapped(_ cell: AudioCell)
    
    /// Start download tapped. Calls when user start downloading.
    ///
    /// - Parameter cell: The audio cell.
    func startDownloadTapped(_ cell: AudioCell)
}
