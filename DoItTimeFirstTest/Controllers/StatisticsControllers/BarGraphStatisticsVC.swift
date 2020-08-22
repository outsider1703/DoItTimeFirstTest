//
//  BarGraphStatisticsVC.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 07.08.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit
import CoreData
import Charts

class BarGraphStatistics: UIViewController, ChartViewDelegate {
    
    private var purposes: [Purpose] = []
    
    var barChartView: BarChartView = {
        let barChart = BarChartView()
        
        return barChart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        purposes = CoreDataManager.shared.fetchData()
        
        barChartView.delegate = self
        creatingAndReceivingEntrie()
        
        view.addSubview(barChartView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        barChartView.frame = CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width)
        barChartView.center = view.center
    }
    @IBAction func selectStatisticsForBar(_ sender: UISegmentedControl) {
        creatingAndReceivingEntrie(sender.selectedSegmentIndex)
    }
    
}

extension BarGraphStatistics {
    private func creatingAndReceivingEntrie(_ indexAtSegment: Int? = nil) {
        let entrieTest = BarChartDataEntry(x: 1, yValues: [1, 2.4, 5])
        let entrie = BarChartDataEntry(x: 2, yValues: [2, 3, 4])
        
        creatingAndReceivingSet(entries: [entrie, entrieTest])
    }
    
    private func creatingAndReceivingSet(entries: [BarChartDataEntry]) {
        let setForDataChart = BarChartDataSet(entries: entries, label: nil)
        
        setForDataChart.colors = ChartColorTemplates.pastel()
        
        creatingAndReceivingData(set: setForDataChart)
    }
    
    private func creatingAndReceivingData(set: BarChartDataSet) {
        let dataForCharts = BarChartData(dataSet: set)
        
        barChartView.data = dataForCharts
    }
    
}
