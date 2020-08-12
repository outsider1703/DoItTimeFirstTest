//
//  InformationViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 08.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet var allTimeLabel: UILabel!
    @IBOutlet var timeOfChoiceLabel: UILabel!
    
    var swipeCellInfo: Purpose!
    var allTime: Int64 {
        getAllTime() / 60
    }
    
    var specificTime: Int64 {
        get {
            getSpecificTime()
        }
        set {
            timeOfChoiceLabel.text = "Time today: \(newValue) minutes"
        }
    }
    
    // let color = UIColor.init(named: "red")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = swipeCellInfo.name
        allTimeLabel.text = "All Time: \(allTime) min"
        timeOfChoiceLabel.text = "Time today: \(specificTime) minutes"
    }
    
    @IBAction func selectStatistics(_ sender: UISegmentedControl) {
        specificTime = getSpecificTime(sender.selectedSegmentIndex)
    }
    
    @IBAction func addLostTime(_ sender: UIButton) {
        editLostTimeAlert(title: "Add lost time", flag: "plus")
    }
    
    @IBAction func removeLostTime(_ sender: UIButton) {
        editLostTimeAlert(title: "Remove lost time", flag: nil)
    }
    
    @IBAction func editInfoForObject(_ sender: UIBarButtonItem) {
        editInfoAlert(title: "Edit Name")
    }
    
}

extension InformationViewController {
    
    private func getAllTime() -> Int64 {
        var allTime: Int64 = 0
        guard let time = swipeCellInfo.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? TimeData
            allTime += timeDataOmbject?.timeCounter ?? 0
        }
        return allTime
    }
    
    private func getSpecificTime(_ indexAtSegment: Int? = nil) -> Int64 {
        var timeForSpecificDate: Int64 = 0
        let calendar = Calendar.current
        
        guard let time = swipeCellInfo.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? TimeData
            
            var dateComponentsForObject: DateComponents?
            var dateComponentsForDate: DateComponents?
            
            switch indexAtSegment {
            case 1:
                dateComponentsForObject = calendar.dateComponents([.weekOfMonth, .month, .year], from: (timeDataOmbject?.date)!)
                dateComponentsForDate = calendar.dateComponents([.weekOfMonth, .month, .year], from: (Date()))
            case 2:
                dateComponentsForObject = calendar.dateComponents([.month, .year], from: (timeDataOmbject?.date)!)
                dateComponentsForDate = calendar.dateComponents([.month, .year], from: (Date()))
            case 3:
                dateComponentsForObject = calendar.dateComponents([.year], from: (timeDataOmbject?.date)!)
                dateComponentsForDate = calendar.dateComponents([.year], from: (Date()))
            default:
                dateComponentsForObject = calendar.dateComponents([.day, .month, .year], from: (timeDataOmbject?.date)!)
                dateComponentsForDate = calendar.dateComponents([.day, .month, .year], from: (Date()))
            }
            
            if dateComponentsForObject == dateComponentsForDate {
                timeForSpecificDate += timeDataOmbject?.timeCounter ?? 0
            }
        }
        return timeForSpecificDate / 60
    }
}

extension InformationViewController {
    
    private func editLostTimeAlert(title: String, flag: String?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let addTime = alert.textFields?.first?.text, !addTime.isEmpty else { return }
            
            switch flag {
            case "plus":
                CoreDataManager.shared.updateTime(self.swipeCellInfo, newTime: (Int64(addTime) ?? 0) * 60 ) // test
            default:
                CoreDataManager.shared.updateTime(self.swipeCellInfo, newTime: -(Int64(addTime) ?? 0) * 60 ) // test
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (text) in
            text.placeholder = "minutes"
        }
        present(alert, animated: true)
    }
    
    private func editInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            CoreDataManager.shared.editName(self.swipeCellInfo, newName: newName)
            self.navigationItem.title = newName
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (text) in
            text.text = self.swipeCellInfo.name
        }
        present(alert, animated: true)
    }
}
