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
    private let coreDataCtrl = CoreDataController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let name = playerNameTF.text, let age = playerAgeTF.text else {return}
        
        DispatchQueue.main.async {
            let player = Player(context: self.coreDataCtrl.mainCtx)
            player.name = name
            if let age = Int16(age) {
                player.age = age
            }
            self.coreDataCtrl.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
