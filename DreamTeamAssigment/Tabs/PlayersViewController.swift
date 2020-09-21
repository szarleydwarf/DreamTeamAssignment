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
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
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
}

extension PlayersViewController : UITableViewDataSource, UITableViewDelegate{

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

        
        self.navigationController?.pushViewController(editPlayerViewController, animated: true)
    }
}
