//
//  Audio.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 19/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation

/**
 The `Audio` is class that contains properties of the audio.
 */
class AudioItem {
    
    // MARK: - Properties
    
    /// The ID.
    var id: Int
    
    /// The song's url.
    let url: String
    
    /// The song's title.
    let title: String
    
    /// The song's artist.
    let artist: String
    
    /// The song's duration.
    let duration: Int
    
    /// The owner ID.
    var ownerID: Int
    
    // MARK: - Initialization
    
    /**
     Initialized server data parameters.
     
     - parameter serverData: The dict.
     */
    init(serverData: [String: AnyObject]) {
        
        id = serverData["id"] as! Int
        url = "\(serverData["url"]!)"
        title = "\(serverData["title"]!)"
        artist = "\(serverData["artist"]!)"
        duration = serverData["duration"] as! Int
        ownerID = serverData["owner_id"] as! Int
    }
    
    /**
     Creates `Audio` with specified properties.
     
     - parameter url: The song's url.
     - parameter title: The song's title.
     - parameter artist: The song's artist.
     - parameter duration: The song's duration.
     
     - returns: The `Audio` instance.
     */
    init(id: Int, ownerID: Int, url: String, title: String, artist: String , duration: Int) {
        self.id = id
        self.url = url
        self.title = title
        self.artist = artist
        self.ownerID = ownerID
        self.duration = duration
    }
}
