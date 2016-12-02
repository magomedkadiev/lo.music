//
//  RealmManager.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 30/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import Foundation
import RealmSwift

/**
 The Realm Manager. Contains all operations connected with realm db.
 */
class RealmManager {
    
    // MARK: - Properties
    
    /// The singltone for relam manager.
    static let shared = RealmManager()
    
    /// The vk's audios from realm.
    var audios: Results<SavedAudio> {
        return try! Realm().objects(SavedAudio.self)
    }
    
    // MARK: - Save Audio
    
    /**
     Call when begin saving process.
     */
    func saveAudios(audio: Audio) {
        let realm = try! Realm()
        realm.beginWrite()
    
        let savedAudio = SavedAudio()
        
        savedAudio.id = audio.id
        savedAudio.url = audio.url
        savedAudio.title = audio.title
        savedAudio.artist = audio.artist
        savedAudio.duration = audio.duration
        
        realm.add(savedAudio, update: true)
            
        try! realm.commitWrite()
    }
    
    func removeLocalAudioThatNotContainsInResponse(response: [Audio]) {
        let realm = try! Realm()

        realm.beginWrite()
        
        let audiosIdsThatShouldNotDelete = response.map { $0.id }
        let audioToDelete = realm.objects(SavedAudio.self).filter("not id in %@", audiosIdsThatShouldNotDelete)
        
        realm.delete(audioToDelete)
        
        try! realm.commitWrite()
    }
}
