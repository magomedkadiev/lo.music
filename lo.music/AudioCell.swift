//
//  AudioCell.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 19/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import MDSOfferView

/**
 The `AudioCell` is a base class for the list audio.
 */
class AudioCell: UITableViewCell {

    // MARK: - Properties
    
    /// The title label.
    @IBOutlet weak var titleLabel: UILabel!
    
    /// The artist label.
    @IBOutlet weak var artistLabel: UILabel!
    
    //@IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var offerView: MDSOfferView!
    
    /// Object of download action delegate.
    var delegate: DownloadActionDelegate?
    
    // MARK: - Actions
    
    var audio: Audio? {
        didSet {
            self.offerView.actionButton.setBackgroundImage(#imageLiteral(resourceName: "download"), for: .normal)
            self.offerView.setTitle("", for: .normal)
            self.offerView.tintColor = nil
            self.offerView.actionButton.layer.cornerRadius = 0
            self.offerView.actionButton.layer.borderWidth = 0
            
            self.offerView.actionHandler = { _ in
                
                switch MDSOfferViewState(rawValue: self.offerView.state.rawValue)! {
                case .downloading, .pendingDownload:
                    self.delegate?.stopDownloadTapped(self)
                case .normal:
                    self.offerViewTapped()
                    self.delegate?.startDownloadTapped(self)
                default:
                    Log.addMessage(message: "Default downlaod state", type: .debug)
                }
            }
        }
    }
    
    func offerViewTapped() {
        self.offerView.setTitle("", for: .normal)
        self.offerView.state = .pendingDownload
    } 
    
}
