//
//  GraphStatisticsVC.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 17.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class GraphStatistics: UIViewController {
    
    @IBOutlet var timeForAllAppLabel: UILabel!
    var allPurposes: [Purpose] = []
    
    var allTime: Int64 {
        getAllTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allPurposes = CoreDataManager.shared.fetchData()
        
        timeForAllAppLabel.text = "All the time at work: \(allTime) minutes."
    }
}

//MARK: - Private Function
extension GraphStatistics {
    private func getAllTime() -> Int64 {
        var allTime: Int64 = 0
        
        for tasks in allPurposes {
            guard let time = tasks.time else { return 0 }
            for object in time {
                let timeCountInTask = object as? TimeData
                allTime += timeCountInTask?.time ?? 0
            }
        }
        return allTime / 60
    }
}
