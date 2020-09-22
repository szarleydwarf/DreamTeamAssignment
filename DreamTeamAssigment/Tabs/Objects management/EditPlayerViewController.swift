//
//  EditPlayerViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 21/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit


class EditPlayerViewController: UIViewController {
    
    @IBOutlet weak var playerNameTF: UITextField!
    @IBOutlet weak var playerAgeTF: UITextField!
    @IBOutlet weak var teamNameTF: UITextField!
    private let coreDataCtrl = CoreDataController.shared
    var player:Player?
    var teams:[Team]=[]
    
    let teamVievController: TeamsViewController = TeamsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerNameTF.text = self.player?.name
        self.playerAgeTF.text = "\(self.player?.age ?? 0)"

        if let teamName = self.player?.relationshipWithTeam?.teamName {
            self.teamNameTF.text = teamName
        }
        
        do {
            try self.teamVievController.fetchResultCtrl.performFetch()
        } catch let err as NSError{
            print("Edit player fetchCtrl ERR \(err.userInfo) >>> \(err.localizedDescription) >>> \(err) <<<")
        }
        if let fetchedTeams = self.teamVievController.fetchResultCtrl.fetchedObjects{
            self.teams = fetchedTeams
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let name = playerNameTF.text, let age = playerAgeTF.text else {return}
      
        DispatchQueue.main.async {
            if let playerRecord = self.player {
              playerRecord.setValue(name, forKey: "name")
              playerRecord.setValue(Int16(age), forKey: "age")
          }
            
            self.coreDataCtrl.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
