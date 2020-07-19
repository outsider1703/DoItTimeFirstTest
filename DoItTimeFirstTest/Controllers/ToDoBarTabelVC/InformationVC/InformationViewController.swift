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
    var testDate: Int64 {
        getDate() / 60
    }
   // let color = UIColor.init(named: "red")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = swipeCellInfo.name
        allTimeLabel.text = "All Time: \(allTime) minutes"
        timeOfChoiceLabel.text = "Time today: \(testDate) minutes"
    }
    
    @IBAction func selectStatistics(_ sender: UISegmentedControl) {
    }
    
    @IBAction func editInfoForObject(_ sender: UIBarButtonItem) {
        showAlert(title: "New Name")
    }
    
}

extension InformationViewController {
    
    private func getAllTime() -> Int64 {
        var allTime: Int64 = 0
        guard let time = swipeCellInfo.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? TimeData
            allTime += timeDataOmbject?.time ?? 0
        }
        return allTime
    }
    
    private func getDate() -> Int64 {
        var textDate: Int64 = 0
        
        let calendar = Calendar.current
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEE, MMM d, ''yy"
        
        guard let time = swipeCellInfo.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? TimeData
            
            let dateComponentsForObject = calendar.dateComponents([.day, .month, .year], from: (timeDataOmbject?.date)!)
            let dateComponentsForDate = calendar.dateComponents([.day, .month, .year], from: (Date()))
            
            if dateComponentsForObject == dateComponentsForDate {
                textDate += timeDataOmbject?.time ?? 0
            }
        }
        return textDate
    }
    //    private func compareDates(dateObjeckt: String) -> Int {
    //        let date = Date()
    //        let calendar = Calendar.current
    //        let dateFormater = DateFormatter()
    //        dateFormater.dateFormat = "EEE, MMM d, ''yy"
    //        let dateComponents = calendar.dateComponents([.day, .month, .year], from: (date))
    //        let ttextDate = calendar.date(from: dateComponents)
    //        let testDay = dateFormater.string(from: ttextDate!)
    //
    // }
}

extension InformationViewController {
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            CoreDataManager.shared.editName(self.swipeCellInfo, newName: task)
            self.navigationItem.title = task
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()

        present(alert, animated: true)
    }
}
