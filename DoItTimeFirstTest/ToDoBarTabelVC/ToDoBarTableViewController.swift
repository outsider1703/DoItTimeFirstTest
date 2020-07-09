//
//  ToDoBarTableViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 05.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ToDoBarTableViewController: UITableViewController {
    
    var purposes: [Purpose] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        purposes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(exactly: 65)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityTableViewCell
        
        cell.nameActivityLabel.text = purposes[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archiveAction = swipeForArchive(at: indexPath)
        return UISwipeActionsConfiguration(actions: [archiveAction])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let infoAction = swipeForInformation(at: indexPath)
        return UISwipeActionsConfiguration(actions: [infoAction])
    }
}

//MARK: - Private Function
extension ToDoBarTableViewController {
    private func reloadRows() {
        let indexPath = IndexPath(row: purposes.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func swipeForArchive(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Archive") { (_, _, completion) in
            completion(true)
        }
        action.image = UIImage(systemName: "archivebox")
        action.backgroundColor = .systemYellow
        return action
    }
    
    private func swipeForInformation(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Info") { (_, _, completion) in
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
            let testInfo = segue.destination as? InformationViewController
            let indexPath = IndexPath(row: purposes.count - 1, section: 0)
            testInfo?.testInfo = purposes[indexPath.row].name
        }
    }
}

//MARK: - Alerts
extension ToDoBarTableViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Achieve This", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            let purposesTask = Purpose(name: task, time: nil)
            self.purposes.append(purposesTask)
            
            self.reloadRows()
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
    }
    
    @objc private func addTask() {
        showAlert(title: "New Goals")
    }
}

