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

//MARK: - Core Data Functions
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
    
    func updateTime(_ task: Purpose, newTime: Int64) {
        
        let dateObject = TimeData(context: viewContext)
        dateObject.date = Date()
        dateObject.timeCounter = newTime
        
        let newTimeForTask = task.time?.mutableCopy() as? NSMutableOrderedSet
        newTimeForTask?.add(dateObject)
        task.time = newTimeForTask
        
        saveContext()
    }
    
    func editName(_ task: Purpose, newName: String) {
        task.name = newName
        saveContext()
    }
    
    func saveStartDate(_ task: Purpose) {
        task.startDate = Date()
        saveContext()
    }
    
    func deleteStartDate(_ task: Purpose) {
        task.startDate = nil
        saveContext()
    }
    
    func saveStartTime(_ task: Purpose, awakeTime: Int64) {
        task.startTime = awakeTime
        saveContext()
    }
    
    func deleteStartTime(_ task: Purpose) {
        task.startTime = 0
        saveContext()
    }
}
//MARK: - Core Data Function for Archive
extension CoreDataManager {
    func addToArchive(task: Purpose) {
        
        guard let entityDescription = NSEntityDescription.entity(
            forEntityName: "ArchivePurpose",
            in: viewContext
            ) else { return }
        guard let archiveTask = NSManagedObject(
            entity: entityDescription,
            insertInto: viewContext
            ) as? ArchivePurpose else { return }
        
        archiveTask.name = task.name
        
        let newSetForArchive = archiveTask.time?.mutableCopy() as? NSMutableOrderedSet
        guard let time = task.time else { return }
        
        for object in time {
            guard let timeDataOmbject = object as? TimeData else { return }
            let timeForArchiveTask = ArchiveTimeData(context: viewContext)
            timeForArchiveTask.timeCounter = timeDataOmbject.timeCounter
            timeForArchiveTask.date = timeDataOmbject.date
            newSetForArchive?.add(timeForArchiveTask)
        }
        archiveTask.time = newSetForArchive
        
        saveContext()
    }
    
    func fetchDataForArchive() -> [ArchivePurpose] {
        let fetchRequest: NSFetchRequest<ArchivePurpose> = ArchivePurpose.fetchRequest()
        var archivePurposes = [ArchivePurpose]()
        
        do {
            archivePurposes = try viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return archivePurposes
    }
    
    func delete(_ deleteTask: ArchivePurpose) {
        viewContext.delete(deleteTask)
        saveContext()
    }
}
