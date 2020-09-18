//
//  TeamsViewController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 18/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {
    
    @IBOutlet weak var teamsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewTeam(_ sender: UIButton) {
        print("You tap + team btn")
    }
}
