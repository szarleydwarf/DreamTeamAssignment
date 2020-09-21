//
//  NewPlayerViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 21/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class NewPlayerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playerNameTF: UITextField!
    @IBOutlet weak var playerAgeTF: UITextField!
    private let coreDataCtrl = CoreDataController.shared
    var team:Team?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let teamName = team?.teamName {
            self.titleLabel.text = "Adding New Player to '\(teamName)'"
        }
    }
    
    @IBAction func savePlayer(_ sender: UIButton) {
        guard let playerName = playerNameTF.text, let playerAge = playerAgeTF.text else {return}
        
        DispatchQueue.main.async {
            let newPlayer = Player(context: self.coreDataCtrl.mainCtx)
            newPlayer.name = playerName
            if let age = Int16(playerAge) {
                newPlayer.age = age
            }
            if let theTeam = self.team {
                newPlayer.relationshipWithTeam = theTeam
            }
            self.coreDataCtrl.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
