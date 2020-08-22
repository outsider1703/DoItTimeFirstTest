//
//  GraphStatisticsVC.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 17.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import CoreData
import Charts

class PieGraphStatistics: UIViewController, ChartViewDelegate {
    
   private var purposes: [Purpose] = []
    
    var pieChartView: PieChartView = {
        let pieChart = PieChartView()
        pieChart.holeRadiusPercent = 0.3
        // pieChart.holeColor = .black
        pieChart.transparentCircleRadiusPercent = 0.1
        pieChart.centerText = "Minuts"
        
        return pieChart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purposes = CoreDataManager.shared.fetchData()
        
        pieChartView.delegate = self
        creatingAndReceivingEntrie()
        
        view.addSubview(pieChartView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pieChartView.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width)
        pieChartView.center = view.center
    }
    
    @IBAction func selectStatistics(_ sender: UISegmentedControl) {
        creatingAndReceivingEntrie(sender.selectedSegmentIndex)
    }
}

//MARK: - Work with Data
extension PieGraphStatistics {
    
    private func creatingAndReceivingEntrie(_ indexAtSegment: Int? = nil) {
        
        var taskEntries = [PieChartDataEntry]()
        
        for tasks in purposes {
            guard let time = tasks.time else { return }
            
            var timeForSpecificDate: Int64 = 0
            
            for object in time {
                let timeCountInTask = object as? TimeData
                
                let calendar = Calendar.current
                var dateComponentsForObject: DateComponents?
                var dateComponentsForDate: DateComponents?
                switch indexAtSegment {
                case 1:
                    dateComponentsForObject = calendar.dateComponents([.weekOfMonth, .month, .year], from: (timeCountInTask?.date)!)
                    dateComponentsForDate = calendar.dateComponents([.weekOfMonth, .month, .year], from: (Date()))
                case 2:
                    dateComponentsForObject = calendar.dateComponents([.month, .year], from: (timeCountInTask?.date)!)
                    dateComponentsForDate = calendar.dateComponents([.month, .year], from: (Date()))
                case 3:
                    dateComponentsForObject = calendar.dateComponents([.year], from: (timeCountInTask?.date)!)
                    dateComponentsForDate = calendar.dateComponents([.year], from: (Date()))
                default:
                    dateComponentsForObject = calendar.dateComponents([.day, .month, .year], from: (timeCountInTask?.date)!)
                    dateComponentsForDate = calendar.dateComponents([.day, .month, .year], from: (Date()))
                }
                
                if dateComponentsForObject == dateComponentsForDate {
                    timeForSpecificDate += timeCountInTask!.timeCounter / 60
                }
            }
            let entrie = PieChartDataEntry(value: Double(timeForSpecificDate), label: "\(tasks.name!)")
            if entrie.value > 0 {
                taskEntries.append(entrie)
            }
        }
        creatingAndReceivingSet(entries: taskEntries)
    }
    
    private func creatingAndReceivingSet(entries: [PieChartDataEntry]) {
        let setForDataChart = PieChartDataSet(entries: entries, label: nil)
        
        setForDataChart.colors = ChartColorTemplates.pastel()
        
        creatingAndReceivingData(set: setForDataChart)
    }
    
    private func creatingAndReceivingData(set: PieChartDataSet) {
        let dataForCharts = PieChartData(dataSet: set)
        
        pieChartView.data = dataForCharts
    }
}

//MARK: - Private Function
extension PieGraphStatistics {
    
}
