//
//  ToDoBarTableViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 05.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.


import UIKit
import CoreData

class ToDoBarTableViewController: UITableViewController {
    
    var purposes: [Purpose] = []
    var cellByIndex: Purpose?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        purposes = CoreDataManager.shared.fetchData()
        getStartTimeForIndex()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        purposes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityTableViewCell
        
        cell.prepareNameForCell(text: purposes[indexPath.row].name)
        cell.prepareIndexForTag(indexPath: indexPath.row)
        cell.setAwakeTimes(timeCount: purposes[indexPath.row].startTime)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archiveAction = swipeForArchive(at: indexPath)
        return UISwipeActionsConfiguration(actions: [archiveAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        cellByIndex = purposes[indexPath.row]
        let infoAction = swipeForInformation(at: indexPath)
        return UISwipeActionsConfiguration(actions: [infoAction])
    }
}

//MARK: - Private Function
extension ToDoBarTableViewController {
    private func reloadRowsAfterInsert() {
        let indexPath = IndexPath(row: purposes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func swipeForArchive(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Archive") { (_, _, completion) in
            
            let task = self.purposes[indexPath.row]
            self.purposes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.shared.delete(task)
            
            completion(true)
        }
        action.image = UIImage(systemName: "archivebox")
        action.backgroundColor = .systemYellow
        return action
    }
    
    private func swipeForInformation(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Info") { [unowned self] (_, _, completion) in
            self.goToInformationVC(indexPath)
            completion(true)
        }
        action.image = UIImage(systemName: "info")
        action.backgroundColor = .systemGreen
        return action
    }
    
    private func goToInformationVC(_ indexPath: IndexPath) {
        performSegue(withIdentifier: "goToInfo", sender: indexPath)
    }
}

//MARK: - Navigation
extension ToDoBarTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo" {
            guard let cell = cellByIndex else { return }
            let infoVC = segue.destination as! InformationViewController
            infoVC.swipeCellInfo = cell
            cellByIndex = nil
        }        
    }
}

//MARK: - Alert
extension ToDoBarTableViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Achieve This", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            let taskObjectCore = CoreDataManager.shared.getAnObject()
            taskObjectCore?.name = task
            
            self.purposes.append(taskObjectCore!)
            self.reloadRowsAfterInsert()
            
            CoreDataManager.shared.save(taskObjectCore!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
}

//MARK: - Navigation Item
extension ToDoBarTableViewController {
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addTask))
        navigationItem.rightBarButtonItem?.style = .done
    }
    
    @objc private func addTask() {
        showAlert(title: "New Goals")
    }
}

extension ToDoBarTableViewController {
    private func getStartTimeForIndex() {
        let calendar = Calendar.current
        var awakeTime: Int?
        
        for objeckt in purposes {
            if objeckt.startDate != nil {
                let differenceBetweenDates = calendar.dateComponents([.day, .hour, .minute, .second],
                                                   from: objeckt.startDate!,
                                                   to: Date())
                awakeTime = calculationOfAmount(differenceBetweenDates.day,
                                                differenceBetweenDates.hour,
                                                differenceBetweenDates.minute,
                                                differenceBetweenDates.second)
                CoreDataManager.shared.saveStartTime(objeckt, awakeTime: Int64(awakeTime!))
            }
        }
    }
    private func calculationOfAmount(_ day: Int?, _ hour: Int?, _ minute: Int?, _ second: Int?) -> Int {
        var summ = 0
        
        if day != 0 { summ += day! * 86400 }
        if hour != 0 { summ += hour! * 3600 }
        if minute != 0 { summ += minute! * 60 }
        summ += second!
        
        return summ
    }
}


