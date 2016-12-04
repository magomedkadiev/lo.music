//
//  DownloadManager.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 03/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK
import Foundation
import RealmSwift

/// The download manager. Contains all operation connected with downloding audio from network.
class DownloadManager {
    
    // MARK: - Properties
    
    /// The singletone constant.
    static let shared = DownloadManager()
    
    /// Calls when user try to remove file from directory.
    ///
    /// - Parameter item: The save audio item.
    func removeFileByPath(item: SavedAudio) {
        let fileManager = FileManager.default
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        guard let directoryPath = path.first else {
            Log.addMessage(message: "Couldn't find directory path", type: .error)
            return
        }
        let localfilePath = String(describing: "\(directoryPath)/\(item.title)\n\(item.artist).mp3")
        
        do {
            try fileManager.removeItem(atPath: localfilePath)
            Log.addMessage(message: "File successfully removed", type: .info)
            
        } catch let error as NSError {
            Log.addMessage(message: "\(error.debugDescription)", type: .error)
        }
    }
    
    /// Return track index.
    ///
    /// - Parameters:
    ///   - downloadTask: Url session download task.
    ///   - completionHandler: return index Int value.
    func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask, completionHandler: @escaping (_ index: Int?) -> Void) {
        let initialQueue = OperationQueue.current ?? OperationQueue.main
        var targetIndex = 0

        OperationQueue().addOperation {
            if let url = downloadTask.originalRequest?.url?.absoluteString {
                let array = RealmManager.shared.audios.sorted(byProperty: "id", ascending: false)
                
                for (index, track) in array.enumerated() {
                    if url == track.url {
                        targetIndex = index
                        initialQueue.addOperation {
                            completionHandler(targetIndex)
                        }
                    }
                }
            }
        }
    }
    
    /// This method checks if the local file exists at the path generated by localFilePathForUrl
    ///
    /// - Parameters:
    ///   - track: The audio.
    ///   - activeDownloads: Results of active downloads.
    /// - Returns: Bool value. True if file exits in directory.
    func localFileExistsForTrack(_ track: Audio, _ activeDownloads: [String: SavedAudioItem]) -> Bool {
        if let localUrl = localFilePathForUrl(generateFilePath(track), activeDownloads) {
            var isDirectory : ObjCBool = false
            let path = localUrl.path
            let isFileExist = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
            
            return isFileExist
        }
        
        return false
    }
    
    /// Get local file by path.
    ///
    /// - Parameters:
    ///   - previewUrl: The preview url.
    ///   - activeDownloads: Results of active downloads.
    /// - Returns: Url.
    func localFilePathForUrl(_ previewUrl: String, _ activeDownloads: [String: SavedAudioItem]) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let fullPath = documentsPath.appendingPathComponent((activeDownloads[previewUrl]?.fileName) ?? previewUrl)
        return URL(fileURLWithPath:fullPath)
    }
    
    // MARK: - Handler
    
    /// The generator if file path
    ///
    /// - Parameter track: The audio.
    /// - Returns: Return fila path.
    func generateFilePath(_ track: Audio) -> String {
        return "\(track.title)\n\(track.artist).mp3"
    }
}
