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
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
    }
    
    @IBAction func addNewTeam(_ sender: UIButton) {
        print("You tap + team btn")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addNewTeamViewController = storyboard.instantiateViewController(identifier: "NewTeamViewController") as? NewTeamViewController else { return  }
        self.navigationController?.pushViewController(addNewTeamViewController, animated: true)
    }
}

extension TeamsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
