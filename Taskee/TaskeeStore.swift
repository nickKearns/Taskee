//
//  TaskeeStore.swift
//  Taskee
//
//  Created by Nicholas Kearns on 7/7/20.
//  Copyright © 2020 Nicholas Kearns. All rights reserved.
//

import Foundation
import CoreData


class TaskeeStore: NSObject {

    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        // must be given the name of the Core Data model file “LoanedItems”
        let container = NSPersistentContainer(name: "Taskee")

        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions

        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up core data (\(error)).")
            }

        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

     // MARK: - Save Core Data Context
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPersistedData(completion: @escaping (FetchItemsResult) -> Void) {
        
        let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        do {
            let allProjects = try viewContext.fetch(fetchRequest)
            completion(.success(allProjects))
        } catch {
            completion(.failure(error))
        }
        
    }





}


enum FetchItemsResult {
    case success([Project])
    case failure(Error)
}
