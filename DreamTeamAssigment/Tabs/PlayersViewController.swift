//
//  PlayersViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 18/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

class PlayersViewController: UIViewController {
    @IBOutlet weak var playersTableView: UITableView!
    private let coreDataCtr = CoreDataController.shared
    let cellIdentifier = "playerCell"
    
    lazy var fetchResultCtrl: NSFetchedResultsController = { ()->NSFetchedResultsController<Player> in
        
        let fetchedRequest = Player.fetchRequest() as NSFetchRequest<Player>
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchedRequest.sortDescriptors = [nameSort]
        fetchedRequest.fetchBatchSize = 15
            
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchedRequest, managedObjectContext: coreDataCtr.mainCtx, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as NSFetchedResultsControllerDelegate
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchResultCtrl.performFetch()
        } catch let err as NSError{
            print("Team fetchCtrl ERR \(err.userInfo) >>> \(err.localizedDescription) >>> \(err) <<<")
        }
        
        self.playersTableView.dataSource = self
        self.playersTableView.delegate = self
        self.playersTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    @IBAction func addNewPlayer(_ sender: UIButton) {
    }
    
    func getSections() -> [NSFetchedResultsSectionInfo]{
        guard let sections = fetchResultCtrl.sections else {
                  fatalError("No sections no rows")
        }
        return sections
    }
}

extension PlayersViewController : UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSections()[section].numberOfObjects
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return getSections().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sections = getSections()
        if section < sections.count {
            return sections[section] as? String
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        let player = fetchResultCtrl.object(at: indexPath)
        update(cell, with: player)
        
        return cell
    }

    func update(_ cell: UITableViewCell, with player: Player){
        cell.textLabel?.text = player.name
        cell.detailTextLabel?.text = "Age: \(player.age), In team: \(player.relationshipWithTeam?.teamName ?? "NA")"
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editPlayerViewController = storyboard.instantiateViewController(identifier: "EditPlayerViewController") as EditPlayerViewController
        let player = fetchResultCtrl.object(at: indexPath)
        editPlayerViewController.player = player
        
    self.navigationController?.pushViewController(editPlayerViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove"){
            (action, indexPath) in
            let itemToRemove = self.fetchResultCtrl.object(at: indexPath)
            self.coreDataCtr.mainCtx.delete(itemToRemove)
        }
        let editAction = UITableViewRowAction(style: .default, title: "Edit"){
        (action, indexPath) in
            let itemToUpdate = self.fetchResultCtrl.object(at: indexPath)
            self.coreDataCtr.mainCtx.refresh(itemToUpdate, mergeChanges: true)
        }
        return [deleteAction, editAction]
    }
}

extension PlayersViewController : NSFetchedResultsControllerDelegate {
    private var rowAnimation : UITableView.RowAnimation {
        return .fade
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       playersTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       playersTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    playersTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            case .delete:
                if let indexPath = indexPath {
                    playersTableView.deleteRows(at: [indexPath], with: .fade)
            }
            case .update:
                if let indexPath = indexPath {
                    playersTableView.reloadRows(at: [indexPath], with: .fade)
            }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    playersTableView.moveRow(at: indexPath, to: newIndexPath)
            }
            @unknown default:
                fatalError("@unknown default")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
        case .insert:
           playersTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
           playersTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
           break
        case .update:
           break
        }
    }
}
