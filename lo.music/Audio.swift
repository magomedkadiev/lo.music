//
//  SavedAudio.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 30/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import RealmSwift


///  The `Audio` is a model class that contains properties of the audio.
class Audio: Object {
    
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
    
    // MARK: - Initialization
    
    
    /// Creates `Audio` with specified properties.
    ///
    /// - Parameters:
    ///   - id: The ID.
    ///   - url: The song's url.
    ///   - ownerID: The owner ID.
    ///   - title: The song's title.
    ///   - artist: The song's artist.
    ///   - duration: The song's duration.
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
    
    
    /// Static variable.
    ///
    /// - Returns: Primary key.
    override static func primaryKey() -> String? {
        return "id"
    }
}
