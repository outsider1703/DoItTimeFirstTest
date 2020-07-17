//
//  InformationViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 08.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet var testNameInfoLabel: UILabel!
    
    var swipeCellInfo: Purpose!
    var allTime: Int64 {
        (getAllTime() ?? 0) / 60
    }
    
//    var testData: String {
//        getDate() ?? ""
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = swipeCellInfo.name
        testNameInfoLabel.text = "All Time: \(allTime) minutes"
    }
}

extension InformationViewController {
    
    private func getAllTime() -> Int64? {
        var allTime: Int64 = 0
        guard let time = swipeCellInfo.time else { return nil }
        for object in time {
            let timeDataOmbject = object as? TimeData
            allTime += timeDataOmbject?.time ?? 0
        }
        return allTime
    }
    
//    private func getDate() -> String? {
//        var textDate: String = ""
//
//        let calendar = Calendar.current
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "EEE, MMM d, ''yy"
//
//        guard let time = swipeCellInfo.time else { return nil }
//        for object in time {
//            let timeDataOmbject = object as? TimeData
//
//            let dateComponents = calendar.dateComponents([.day, .month, .year], from: (timeDataOmbject?.date)!)
//            let ttextDate = calendar.date(from: dateComponents)
//            let testDay = dateFormater.string(from: ttextDate!)
//
//            textDate += testDay
//        }
//        return textDate
//    }
}
