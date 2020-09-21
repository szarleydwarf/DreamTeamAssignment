//
//  TeamsViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 18/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import CoreData

class TeamsViewController: UIViewController {
    
    @IBOutlet weak var teamsTableView: UITableView!
    private let coreDataCtr = CoreDataController.shared
    let cellIdentifier = "teamCell"
    lazy var fetchResultCtrl: NSFetchedResultsController = { ()->NSFetchedResultsController<Team> in
        
        let fetchedRequest = Team.fetchRequest() as NSFetchRequest<Team>
        let nameSort = NSSortDescriptor(key: "teamName", ascending: true)
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
        
        self.teamsTableView.dataSource = self
        self.teamsTableView.delegate = self
        self.teamsTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }
    
    @IBAction func addNewTeam(_ sender: UIButton) {
        
    }
    
    func getTeams() -> [Team]? {
        let teams = self.fetchResultCtrl.fetchedObjects
        return teams
    }
}


extension TeamsViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultCtrl.sections else {
            fatalError("No sections no rows")
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: self.cellIdentifier)
        }
        let team = fetchResultCtrl.object(at: indexPath)
        update(cell, with: team)
        
        return cell
    }
    
    func update(_ cell: UITableViewCell, with team: Team){
        cell.textLabel?.text = team.teamName
        cell.detailTextLabel?.text = "\(team.teamColour ?? "red") with #\(team.relationshipWithPlayer?.count ?? 0) players"
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove"){
            (action, indexPath) in
            let itemToRemove = self.fetchResultCtrl.object(at: indexPath)
            self.coreDataCtr.mainCtx.delete(itemToRemove)
            self.coreDataCtr.save()
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newPlayerViewController = storyboard.instantiateViewController(identifier: "NewPlayerViewController") as NewPlayerViewController
              let team = fetchResultCtrl.object(at: indexPath)
        
        newPlayerViewController.team = team
        self.navigationController?.pushViewController(newPlayerViewController, animated: true)
    }
}

extension TeamsViewController : NSFetchedResultsControllerDelegate {
    private var rowAnimation : UITableView.RowAnimation {
        return .fade
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       teamsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       teamsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    teamsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
            case .delete:
                if let indexPath = indexPath {
                    teamsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            case .update:
                if let indexPath = indexPath {
                    teamsTableView.reloadRows(at: [indexPath], with: .fade)
            }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    teamsTableView.moveRow(at: indexPath, to: newIndexPath)
            }
            @unknown default:
                fatalError("@unknown default")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
        case .insert:
           teamsTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
           teamsTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
           break
        case .update:
           break
        }
    }
}
