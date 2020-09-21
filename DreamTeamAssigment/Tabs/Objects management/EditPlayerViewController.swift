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
    
    var player:Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerNameTF.text = self.player?.name
        self.playerAgeTF.text = "\(self.player?.age ?? 0)"
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let name = playerNameTF.text, let age = playerAgeTF.text else {return}
      
        DispatchQueue.main.async {
            if let oldPlayerRecord = self.player {
                  oldPlayerRecord.setValue(name, forKey: "name")
                  oldPlayerRecord.setValue(Int16(age), forKey: "age")
              }
            
            self.coreDataCtrl.save()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
