//
//  CoreDataController.swift
//  DreamTeamAssigment
//
//  Created by The App Experts on 18/09/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {
    private init() {    }
    
    static let shared = CoreDataController()
    
    var mainCtx: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DreamTeamAssigment")
        container.loadPersistentStores(completionHandler: {(teamDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved lazy error in 'persistentContainer' \(error)")
            }
        })
        return container
    }()
    
    func save() -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do{
                try context.save()
                return true
            } catch{
                let nserror = error as NSError
                fatalError("Unresolve error in CoreDataController.save() \(nserror)")
            }
        }
        
        return false
    }
}
