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
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
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
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: - Core Data Function
extension CoreDataManager {
    
    func getAnObject() -> Purpose? {
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: "Purpose",
            in: viewContext
            ) else { return nil }
        guard let task = NSManagedObject(
            entity: entityDescription,
            insertInto: viewContext
            ) as? Purpose else { return nil }
        
        return task
    }
    
    func save(_ newTask: Purpose) {
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
        saveContext()
    }
    
    func delete(_ deleteTask: Purpose) {
        viewContext.delete(deleteTask)
        saveContext()
    }
    
    func fetchData() -> [Purpose] {
        let fetchRequest: NSFetchRequest<Purpose> = Purpose.fetchRequest()
        var purposes = [Purpose]()
        
        do {
            purposes = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return purposes
    }
}