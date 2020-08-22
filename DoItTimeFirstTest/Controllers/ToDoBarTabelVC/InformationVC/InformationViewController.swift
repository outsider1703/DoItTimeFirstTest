//
//  InformationViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 08.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import CoreData
import Charts

class InformationViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet var allTimeLabel: UILabel!
    @IBOutlet var timeOfChoiceLabel: UILabel!
    
    var swipeCellForInfo: Purpose!
    var allTime: Int64 {
        getAllTime()
    }
    
    var specificTime: Int64 {
        get {
            getSpecificTime()
        }
        set {
            timeOfChoiceLabel.text = "Time today: \(newValue) minutes"
        }
    }
    
    //    var barChartView: BarChartView = {
    //        let barChart = BarChartView()
    //
    //        return barChart
    //    }()
    //
    // let color = UIColor.init(named: "red")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = swipeCellForInfo.name
        allTimeLabel.text = "All Time: \(allTime) min"
        timeOfChoiceLabel.text = "Time today: \(specificTime) minutes"
        
        //        barChartView.delegate = self
        //        creatingAndReceivingEntrie()
        //
        //        view.addSubview(barChartView)
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        barChartView.frame = CGRect(x: 0, y: 0,
    //                                    width: self.view.frame.size.width,
    //                                    height: self.view.frame.size.width)
    //        barChartView.center = view.center
    //    }
    
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
    @IBAction func backToGoalsButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushToArchiveButton(_ sender: UIButton) {
        CoreDataManager.shared.addToArchive(task: swipeCellForInfo)
        CoreDataManager.shared.delete(swipeCellForInfo)
    }
    
}
//MARK: - Work with Chart
extension InformationViewController {
    //    private func creatingAndReceivingEntrie(_ indexAtSegment: Int? = nil) {
    //        let entrieTest = BarChartDataEntry(x: 1, yValues: [1, 2.4, 5])
    //        let entrie = BarChartDataEntry(x: 2, yValues: [2, 3, 4])
    //
    //        creatingAndReceivingSet(entries: [entrie, entrieTest])
    //    }
    //
    //    private func creatingAndReceivingSet(entries: [BarChartDataEntry]) {
    //        let setForDataChart = BarChartDataSet(entries: entries, label: nil)
    //
    //        setForDataChart.colors = ChartColorTemplates.pastel()
    //
    //        creatingAndReceivingData(set: setForDataChart)
    //    }
    //
    //    private func creatingAndReceivingData(set: BarChartDataSet) {
    //        let dataForCharts = BarChartData(dataSet: set)
    //
    //        barChartView.data = dataForCharts
    //    }
    
    
}

extension InformationViewController {
    
    private func getAllTime() -> Int64 {
        var allTime: Int64 = 0
        guard let time = swipeCellForInfo.time else { return 0 }
        for object in time {
            let timeDataOmbject = object as? TimeData
            allTime += timeDataOmbject?.timeCounter ?? 0
        }
        return allTime / 60
    }
    
    private func getSpecificTime(_ indexAtSegment: Int? = nil) -> Int64 {
        var timeForSpecificDate: Int64 = 0
        let calendar = Calendar.current
        
        guard let time = swipeCellForInfo.time else { return 0 }
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
//MARK: - Alerts
extension InformationViewController {
    
    private func editLostTimeAlert(title: String, flag: String?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
            guard let addTime = alert.textFields?.first?.text, !addTime.isEmpty else { return }
            
            switch flag {
            case "plus":
                CoreDataManager.shared.updateTime(self.swipeCellForInfo, newTime: (Int64(addTime) ?? 0) * 60 ) // test
            default:
                CoreDataManager.shared.updateTime(self.swipeCellForInfo, newTime: -(Int64(addTime) ?? 0) * 60 ) // test
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (text) in
            text.placeholder = "minutes"
            text.keyboardType = .numberPad
        }
        present(alert, animated: true)
    }
    
    private func editInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] _ in
            guard let newName = alert.textFields?.first?.text, !newName.isEmpty else { return }
            CoreDataManager.shared.editName(self.swipeCellForInfo, newName: newName)
            self.navigationItem.title = newName
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (text) in
            text.text = self.swipeCellForInfo.name
        }
        present(alert, animated: true)
    }
}
