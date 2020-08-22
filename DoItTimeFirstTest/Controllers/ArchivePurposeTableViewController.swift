//
//  ArchivePurposeTableViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 13.08.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import CoreData

class ArchivePurposeTableViewController: UITableViewController {
    
    var archivePurposes: [ArchivePurpose] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archivePurposes = CoreDataManager.shared.fetchDataForArchive()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivePurposes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveCell", for: indexPath)
        
        cell.textLabel?.text = archivePurposes[indexPath.row].name
        cell.detailTextLabel?.text = "\(getAllTimeFor(task: archivePurposes[indexPath.row]))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CoreDataManager.shared.delete(archivePurposes[indexPath.row])
    }
    
    private func getAllTimeFor(task: ArchivePurpose) -> Int64 {
        var allTime: Int64 = 0
        guard let time = task.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? ArchiveTimeData
            allTime += timeDataOmbject?.timeCounter ?? 0
        }
        return allTime / 60
    }
}
