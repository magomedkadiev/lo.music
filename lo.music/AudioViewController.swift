//
//  AudioViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 16/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import SwiftyVK
import RealmSwift

/**
 The `AudioViewController` is a view controller of the list audio scene.
 */
class AudioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate, URLSessionDownloadDelegate, DownloadActionDelegate {
    
    // MARK: - Properties

    /// The table view.
    @IBOutlet weak var tableView: UITableView!
    
    /// The refresh control for pull two refresh gesture.
    var tableViewRefreshControl = UIRefreshControl()
    
    var activeDownloads = [String: SavedAudioItem]()
    
    /// The download session.
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    /// The audios. Result of `Realm`'s query.
    private var allAudios: Results<Audio>! {
        didSet {
            audiosNotificationToken?.stop()
            
            audiosNotificationToken = allAudios.addNotificationBlock {
                [weak self] (changes: RealmCollectionChange) in
                
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .bottom)
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .none)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
                    tableView.endUpdates()
                case .error(let error):
                    Log.addMessage(message: "\(error)", type: .error)
                }
                
            }
        }
    }
    
    /// The persons' notification token. Used to receive notifications about persons' changes in the `Realm`.
    private var audiosNotificationToken: NotificationToken!
    
    // MARK: - Initialization.
    
    /**
     Initializes a view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard VK.state == .authorized else {
            Log.addMessage(message: "User is not authorized", type: .debug)
            return
        }
        
        syncAudios()
        _ = downloadsSession

        allAudios = RealmManager.shared.audios.sorted(byProperty: "id", ascending: false)
        addRefreshControl()
    }
    
    
    /// Calls reloadData to update all download components if nedeed.
    ///
    /// - Parameter animated: animated value.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard activeDownloads.count == 0 else {
            return
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Deinitialization
    
    /**
     Stops `Realm` notifications.
     */
    deinit {
        audiosNotificationToken?.stop()
    }
    
    // MARK: - View setup
    
    /**
     Add tableViewController as a childViewController and set its tableView property to your UITableView.
     */
    func addRefreshControl() {
        let tableViewController = UITableViewController()
        
        addChildViewController(tableViewController)
        tableViewController.tableView = self.tableView
        tableViewRefreshControl.addTarget(self, action: #selector(syncAudios), for: .valueChanged)
        tableViewController.refreshControl = tableViewRefreshControl
    }
    
    // MARK: - Requests
    
    /**
     Load audios from internet.
     */
    @objc private func syncAudios() {
        RequestManager.shared.getAudios { (error) in
            
            guard error == nil else {
                Log.addMessage(message: error!.localizedDescription, type: .debug)
                return
            }
            Log.addMessage(message: "All audios successfuly loaded.", type: .info)
            self.tableViewRefreshControl.endRefreshing()
            
        }
    }
    
    // MARK: - UITableViewDataSource
    
    /**
     Return count rows in table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAudios.count
    }
    
    /**
     Initializes `allAudios.count` rows.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "audioCell") as! AudioCell
        let audio = allAudios[indexPath.row]
        
        cell.titleLabel.text = allAudios[indexPath.row].title
        cell.artistLabel.text = allAudios[indexPath.row].artist
        cell.delegate = self
        
        var showDownloadControls = false
        if let download = activeDownloads[audio.url] {
            showDownloadControls = true
            cell.progressView.progress = download.progress
           // cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
        }
        
        cell.progressView.isHidden = !showDownloadControls
        //cell.progressLabel.isHidden = !showDownloadControls
       // cell.trackDurationLabel.isHidden = showDownloadControls
        
        let downloaded = DownloadManager.shared.localFileExistsForTrack(audio, activeDownloads)
        cell.stopDownloadButton.isHidden = !showDownloadControls
        cell.startDownloadButton.isHidden = showDownloadControls
        if downloaded {
            cell.accessoryType = .checkmark
            cell.startDownloadButton.isHidden = true
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func currentTimeMillis() -> String {
        let nowDouble = NSDate().timeIntervalSince1970
        return "\(Int64(nowDouble*1000))"
    }
    
    // MARK: - DownloadActionDelegate
    
    /// Start download.
    ///
    /// - Parameter cell: The current tapped cell.
    func startDownloadTapped(_ cell: AudioCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = allAudios[(indexPath as NSIndexPath).row]
            startDownload(track: track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    /// Stop download.
    ///
    /// - Parameter cell: The current tapped cell.
    func stopDownloadTapped(_ cell: AudioCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = allAudios[(indexPath as NSIndexPath).row]
            stopDownload(track: track)
            tableView.reloadRows(at: [IndexPath(row: (indexPath as NSIndexPath).row, section: 0)], with: .none)
        }
    }
    
    // MARK: - Download methods.
    
    /// Start downloading method.
    ///
    /// - Parameter track: Prepared track.
    private func startDownload(track: Audio) {
        let urlString = track.url
        let url =  URL(string: urlString)
        let download = SavedAudioItem(url: urlString)
        download.downloadTask = downloadsSession.downloadTask(with: url!)
        download.downloadTask!.resume()
        download.isDownloading = true
        download.fileName = DownloadManager.shared.generateFilePath(track)
        download.songName = track.title
        
        // Prepare properties for saving into realm.
        download.id = track.id
        download.title = track.title
        download.artist = track.artist
        download.duration = track.duration
        download.date = currentTimeMillis()
        
        activeDownloads[download.url] = download
    }
    
    /// Stop downloading method.
    ///
    /// - Parameter track: Prepared track.
    private func stopDownload(track: Audio?) {
        if let urlString = track?.url, let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    // MARK: - NSURLSessionDelegate
    
    /**
     Tells the delegate that all messages enqueued for a session have been delivered.
     */
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async(execute: {
                    completionHandler()
                })
            }
        }
    }
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let originalURL = downloadTask.originalRequest?.url?.absoluteString,
            let destinationURL = DownloadManager.shared.localFilePathForUrl(originalURL, activeDownloads) {
            let fileManager = FileManager.default
            
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
                //Log.addMessage(message: "File probably doesn't exist", type: .error)
            }
            
            do {
                try fileManager.moveItem(at: location, to: destinationURL)
                let savedAudio = self.activeDownloads[originalURL]!
                
                RealmManager.shared.saveDownloadAudio(item: savedAudio)
                Log.addMessage(message: "Download audios succssfully saved.", type: .info)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    Log.addMessage(message: "Donwload complete", type: .debug)
                    let url = downloadTask.originalRequest?.url?.absoluteString
                    self.activeDownloads[url!] = nil
                })
            } catch let error as NSError {
                DispatchQueue.main.async(execute: { () -> Void in
                    Log.addMessage(message: "Error/Stop downloading", type: .error)
                    let url = downloadTask.originalRequest?.url?.absoluteString
                    self.activeDownloads[url!] = nil
                })
                Log.addMessage(message: "Could not copy file to disk: \(error.localizedDescription)", type: .error)
            }
        }
        
        DownloadManager.shared.trackIndexForDownloadTask(downloadTask, completionHandler: { (index) in
            if let trackIndex = index {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                })
            }
        })
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let downloadUrl = downloadTask.originalRequest?.url?.absoluteString,
            let download = activeDownloads[downloadUrl] {
            download.progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
            download.size = Double(totalBytesExpectedToWrite)
            let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: ByteCountFormatter.CountStyle.binary)
            
            DownloadManager.shared.trackIndexForDownloadTask(downloadTask, completionHandler: { (index) in
                if let trackIndex = index,
                    let trackCell = self.tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? AudioCell {
                    DispatchQueue.main.async(execute: {
                        let bitRate = String(Int(totalBytesExpectedToWrite) * 8 / 1000 / download.duration)
                        let progress = String(format: "%.1f%% of %@",  download.progress * 100, totalSize) + " \(bitRate)kbps"
                        
                        trackCell.progressView.isHidden = false
                        trackCell.progressView.progress = download.progress
                        Log.addMessage(message:  (progress), type: .info)
                        // Show download progress for user.
                    })
                }
            })
        }
    }
}
