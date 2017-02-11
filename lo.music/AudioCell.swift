//
//  AudioCell.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 19/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import MDSOfferView


///  The `AudioCell` is a base class for the list audio.
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
    
    /// The audio object.
    var audio: Audio? {
        didSet {
            setupOfferView(.normal, #imageLiteral(resourceName: "download"))
            
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
    
    
    /// Setup offer view parameters.
    ///
    /// - Parameters:
    ///   - state: MDSOfferViewState.
    ///   - backgroundImage: The background image.
    func setupOfferView(_ state: MDSOfferViewState, _ backgroundImage: UIImage?) {
        offerView.state = state
        offerView.enabled = true
        offerView.setTitle("", for: .normal)
        offerView.actionButton.setTitle("", for: .normal)
        offerView.actionButton.setBackgroundImage(backgroundImage, for: .normal)
        offerView.actionButton.layer.cornerRadius = 0
        offerView.actionButton.layer.borderWidth = 0
    }
    
    
    /// Change offer view state when user tapped to download button.
    func offerViewTapped() {
        self.offerView.setTitle("", for: .normal)
        self.offerView.state = .pendingDownload
    }
    
}
