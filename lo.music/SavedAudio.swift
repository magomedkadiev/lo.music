//
//  SavedAudio.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 04/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import RealmSwift

/**
 The `Audio` is a model class that contains properties of the audio.
 */
class SavedAudio: Object {
    
    // MARK: - Properties
    
    /// The ID.
    dynamic var id = 0
    
    /// The song's url.
    dynamic var url = ""
    
    /// The song's title.
    dynamic var title = ""
    
    /// The song's artist.
    dynamic var artist = ""
    
    /// The song's duration.
    dynamic var duration = 0
    
    /// The ownerID.
    dynamic var ownerID = 0
    
    /// The saved date.
    dynamic var date = ""
    
    /// The sorted parameter.
    dynamic var order = 0
    
    /// The size of audio.
    dynamic var size: Double = 0.0
    
    // MARK: - Initialization
    
    /**
     Creates `Audio` with specified properties.
     
     - parameter id: The ID.
     - parameter url: The song's url.
     - parameter title: The song's title.
     - parameter artist: The song's artist.
     - parameter duration: The song's duration.
     
     - returns: The `Audio` instance.
     */
    convenience init(id: Int,
                     url: String,
                     ownerID: Int,
                     title: String,
                     artist: String,
                     duration: Int){
        self.init()
        
        self.id = id
        self.url = url
        self.title = title
        self.artist = artist
        self.ownerID = ownerID
        self.duration = duration
    }
    
    /**
     Sets primary key.
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
