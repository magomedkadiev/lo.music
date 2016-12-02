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
class AudioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate {
    
    // MARK: - Properties

    /// The table view.
    @IBOutlet weak var tableView: UITableView!
    
    /// The refresh control for pull two refresh gesture.
    var tableViewRefreshControl = UIRefreshControl()
    
    /// The download session.
    lazy var downloadsSession: Foundation.URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    /// The audios. Result of `Realm`'s query.
    private var allAudios: Results<SavedAudio>! {
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
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .bottom)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .bottom)
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
        
        cell.titleLabel.text = allAudios[indexPath.row].artist
        cell.artistLabel.text = allAudios[indexPath.row].title
        
        return cell
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

}
