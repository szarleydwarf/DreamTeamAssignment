//
//  NewTeamViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 18/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class NewTeamViewController: UIViewController {
    @IBOutlet weak var teamNameTF: UITextField!
    @IBOutlet weak var teamColourTF: UITextField!
    
    private let coreDataCtr = CoreDataController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func save(_ sender: UIButton) {
        guard let teamName = teamNameTF.text, let teamColour = teamColourTF.text else {
            return
        }
        
        DispatchQueue.main.async {
            let newTeam = Team(context: self.coreDataCtr.mainCtx)
            newTeam.teamName = teamName
            newTeam.teamColour = teamColour
            self.coreDataCtr.save()
        }
    }
    
    
}
