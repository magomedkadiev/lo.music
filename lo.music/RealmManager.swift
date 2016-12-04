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
    var audios: Results<Audio> {
        return try! Realm().objects(Audio.self)
    }
    
    /// The saved audios from realm.
    var savedAudios: Results<SavedAudio> {
        return try! Realm().objects(SavedAudio.self)
    }
    
    // MARK: - Save Audio
    
    /// Save in realm downlaoded from network audio.
    ///
    /// - Parameter item: The audio item.
    func saveAudioFromNet(item: AudioItem) {
        let realm = try! Realm()
        realm.beginWrite()
    
        let audio = Audio()
        
        audio.id = item.id
        audio.url = item.url
        audio.title = item.title
        audio.artist = item.artist
        audio.ownerID = item.ownerID
        audio.duration = item.duration
        
        realm.add(audio, update: true)
            
        try! realm.commitWrite()
    }
    
    /// Save in realm downloaded audio.
    ///
    /// - Parameter item: The saved audio item.
    func saveDownloadAudio(item: SavedAudioItem) {
        let realm = try! Realm()
        realm.beginWrite()

        let savedAudio = SavedAudio()
        
        savedAudio.id = item.id
        savedAudio.url = item.url
        savedAudio.size = toMB(item.size)
        savedAudio.date = item.date
        savedAudio.title = item.title
        savedAudio.artist = item.artist
        savedAudio.ownerID = item.ownerID
        savedAudio.duration = item.duration

        realm.add(savedAudio, update: true)

        try! realm.commitWrite()
    }
    
    /// Remove deleted audios from list of audios from vk.
    ///
    /// - Parameter response: The array of audios.
    func removeLocalAudioThatNotContainsInResponse(response: [AudioItem]) {
        let realm = try! Realm()

        realm.beginWrite()
        
        let audiosIdsThatShouldNotDelete = response.map { $0.id }
        let audioToDelete = realm.objects(Audio.self).filter("not id in %@", audiosIdsThatShouldNotDelete)
        
        realm.delete(audioToDelete)
        
        try! realm.commitWrite()
    }
    
    /// Remove donwload audio.
    ///
    /// - Parameter item: The saved audio item.
    func removeDownloadAudio(item: SavedAudio) {
        let realm = try! Realm()
        realm.beginWrite()
        
        realm.delete(item)
        
        try! realm.commitWrite()
    }
    
    /// Convert bytes to MB.
    ///
    /// - Parameter size: The double value to convert.
    /// - Returns: Converted double value.
    func toMB(_ size: Double) -> Double {
        let mbValue: Double = 1000.0 * 1000.0
        let division = size/mbValue
        
        return Double(round(10*division)/10)
    }
}
