//
//  AudioCell.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 19/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit

/**
 The `AudioCell` is a base class for the list audio.
 */
class AudioCell: UITableViewCell {

    // MARK: - Properties
    
    /// The title label.
    @IBOutlet weak var titleLabel: UILabel!
    
    /// The artist label.
    @IBOutlet weak var artistLabel: UILabel!
    
    /// The start download button.
    @IBOutlet weak var startDownloadButton: UIButton!
    
    /// The stop download button.
    @IBOutlet weak var stopDownloadButton: UIButton!
    
    /// The progress view.
    @IBOutlet weak var progressView: UIProgressView!
    
    /// Object of download action delegate.
    var delegate: DownloadActionDelegate?
    
    // MARK: - Actions
    
    /// Start download action.
    ///
    /// - Parameter sender: Any.
    @IBAction func startDownloadAction(_ sender: AnyObject) {
        delegate?.startDownloadTapped(self)
    }
    
    /// Stop download action
    ///
    /// - Parameter sender: Any.
    @IBAction func stopDownloadAction(_ sender: AnyObject) {
        delegate?.stopDownloadTapped(self)
    }
}
