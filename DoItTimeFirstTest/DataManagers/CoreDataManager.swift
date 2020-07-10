//
//  CoreDataManager.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 10.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SampleData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Core Data Function
extension CoreDataManager {
    
    func save(name: String, time: Int) {
        
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: "Purpose",
            in: persistentContainer.viewContext
            ) else { return }
        guard let task = NSManagedObject(
            entity: entityDescription,
            insertInto: persistentContainer.viewContext
            ) as? Purpose else { return }
        
        task.name = name
        task.time = Int64(time) 
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchData() -> [Purpose] {
        let fetchRequest: NSFetchRequest<Purpose> = Purpose.fetchRequest()
        var purposes = [Purpose]()
        
        do {
          purposes = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return purposes
    }
}
