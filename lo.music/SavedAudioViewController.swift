//
//  SavedAudioViewController.swift
//  lo.music
//
//  Created by Султан Магомедкадиев on 04/12/2016.
//  Copyright © 2016 lo.music. All rights reserved.
//

import UIKit
import RealmSwift

/// The saved audis view controller scene.
class SavedAudioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {

    // MARK: - Properties
    
    /// The table view.
    @IBOutlet weak var tableView: UITableView!
    
    /// The left bar button item.
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    /// Interacted class contains parameters.
    let interactor = Interactor()
    
    /// The saved audio. Result of `Realm`'s query.
    private var allAudios: Results<SavedAudio>! {
        didSet {
            savedAudioNotificationToken?.stop()
            
            savedAudioNotificationToken = allAudios.addNotificationBlock {
                [weak self] (changes: RealmCollectionChange) in
                
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .none)
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
    private var savedAudioNotificationToken: NotificationToken!
    
    // MARK: - Initialization.
    
    /**
     Initializes a view controller.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
 
        allAudios = RealmManager.shared.savedAudios.sorted(byProperty: "date", ascending: false)
    }
  
    /// Calls when user tap to edit button.
    ///
    /// - Parameter sender: Left bar button item.
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            leftBarButtonItem.style = .plain
            leftBarButtonItem.title = "Edit"
        } else{
            tableView.setEditing(true, animated: true)
            leftBarButtonItem.title = "Done"
            leftBarButtonItem.style =  .done
        }
    }
    
    // MARK: - Deinitialization
    
    /**
     Stops `Realm` notifications.
     */
    deinit {
        savedAudioNotificationToken?.stop()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedAudioCell") as! SavedAudioCell
        let audio = allAudios[indexPath.row]
        
        cell.titleLabel.text = audio.title
        cell.artistLabel.text = audio.artist

        return cell
    }
    
    /// Calls when user tapped to cell.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toPlayerScene()
    }
    
    /// Return height for each row.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    /// Calls when user moved a row.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let realm = try! Realm()
        
        try! realm.write {
            let sourceObject = allAudios[sourceIndexPath.row]
            let destinationObject = allAudios[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject.order
            
            if sourceIndexPath.row < destinationIndexPath.row {
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = allAudios[index]
                    object.order -= 1
                }
            } else {
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = allAudios[index]
                    object.order += 1
                }
            }
            sourceObject.order = destinationObjectOrder
        }
    }
    
    /// Calls Bools value can move row.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Calls when user tried to delete row.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let audio = allAudios[indexPath.row]
            
            DownloadManager.shared.removeFileByPath(item: audio)
            RealmManager.shared.removeDownloadAudio(item: audio)
            
            Log.addMessage(message: "Audio successfully removed", type: .info)
        }
    }
    
    // MARK: - Actions
    
    /// Call when user wants to see player scene from tapping to cell.
    func toPlayerScene() {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        viewController.transitioningDelegate = self
        viewController.interactor = interactor
        viewController.hidesBottomBarWhenPushed = true
        self.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    /// The delete method.
    ///
    /// - Parameter dismissed: The view controller.
    /// - Returns: Object value.
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    /// An object that implements the protocol vends the objects used to manage a fixed-length or interactive transition between view controllers
    ///
    /// - Parameter animator: The animator.
    /// - Returns: Bool vaue if interactive transitiong.
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
}
