//
//  ViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 29.06.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cornerRadiusButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCornerRadiusForButtons()
    }
    
    private func settingCornerRadiusForButtons() {
        guard let buttons = cornerRadiusButtons else { return }
        buttons.forEach({ button in
            button.layer.cornerRadius = button.frame.width / 2
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "statisticsTabBar" {
            let tabBarController = segue.destination as! UITabBarController
            let pieChartVC = tabBarController.viewControllers?.first as! PieGraphStatistics
            let barChartVC = tabBarController.viewControllers?.last as! BarGraphStatistics
            
            pieChartVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill",
                                                  withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
            barChartVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill",
                                                  withConfiguration: UIImage.SymbolConfiguration(weight: .thin))
        }
    }
    
}
