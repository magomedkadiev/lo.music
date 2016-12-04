//
//  SavedAudoItem.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 04/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation

/**
 The `SavedAudioItem` is class that contains properties of the saved audio.
 */
class SavedAudioItem {
    
    // MARK: - Properties
    
    /// The ID.
    var id: Int = 0
    
    /// The song's url.
    var url: String = ""
    
    /// The song's title.
    var title: String = ""
    
    /// The song's artist.
    var artist: String = ""
    
    /// The song's duration.
    var duration: Int = 0
    
    /// The owner ID.
    var ownerID: Int = 0
    
    var isDownloading = false

    var progress: Float = 0.0

    var fileName: String = ""

    var songName: String = ""
    
    var date: String = ""
    
    var size: Double = 0

    var downloadTask: URLSessionDownloadTask?

    // MARK: - Initialization

    init(url: String) {
        self.url = url
    }
}
