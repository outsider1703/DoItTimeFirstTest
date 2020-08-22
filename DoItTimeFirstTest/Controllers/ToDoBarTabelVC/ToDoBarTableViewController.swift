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
        
        cell.preparePersonalCell(purposes[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellByIndex = purposes[indexPath.row]
        performSegue(withIdentifier: "goToInfo", sender: nil)
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
            
            CoreDataManager.shared.addToArchive(task: task)
            
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
    
    private func getStartTimeForIndex() {
          for task in purposes {
              if task.startDate != nil {
                  
                  let dateStart = task.startDate!
                  let awakeTime = -Int(dateStart.timeIntervalSinceNow)
                  
                  CoreDataManager.shared.saveStartTime(task, awakeTime: Int64(awakeTime))
              }
          }
      }
}

//MARK: - Navigation
extension ToDoBarTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo" {
            guard let cell = cellByIndex else { return }
            let navigationVC = segue.destination as! UINavigationController
            let infoVC = navigationVC.viewControllers.first as! InformationViewController
            infoVC.swipeCellForInfo = cell
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
