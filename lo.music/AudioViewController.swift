//
//  AudioViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 16/11/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import VKSdkFramework

/**
 The `AudioViewController` is a view controller of the list audio scene.
 */
class AudioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties

    /// The all audios array.
    private var allAudios = [Audio]()

    /// The table view.
    @IBOutlet weak var tableView: UITableView!
    
    /**
     Initializes a view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAudios()
    }
    
    /**
     Load audios from net by userID.
     */
    private func loadAudios() {
        RequestManager.shared.getAudio { (serverData) in
            for data in serverData {
                let audio = Audio(serverData: data as! [String: AnyObject])
                self.allAudios.append(audio)
            }
            self.tableView.reloadData()
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
        
        cell.titleLabel.text = allAudios[indexPath.row].title
        cell.artistLabel.text = allAudios[indexPath.row].artist
        
        return cell
    }

}
