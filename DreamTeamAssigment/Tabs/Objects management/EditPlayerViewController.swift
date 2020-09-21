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
    let picker:UIPickerView? = UIPickerView()
    var player:Player?
    let teamsClass = TeamsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerNameTF.text = self.player?.name
        self.playerAgeTF.text = "\(self.player?.age ?? 0)"
        if let teamName = self.player?.relationshipWithTeam?.teamName {
            self.teamNameTF.text = teamName
        }
        picker?.delegate = self
        self.teamNameTF.inputView = picker
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

extension EditPlayerViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if let count = teamsClass.getTeams()?.count{
            return count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return self.teamsClass.getTeams()?[row].teamName
       }
    
       // When user selects an option, this function will set the text of the text field to reflect
       // the selected option.
       func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.teamNameTF.text = self.teamsClass.getTeams()?[row].teamName
       }
}
