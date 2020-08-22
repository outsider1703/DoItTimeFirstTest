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
            for controller in tabBarController.viewControllers! {
                if let pieChartVC = controller as? PieGraphStatistics {
                    pieChartVC.tabBarItem.image = UIImage(systemName: "chart.pie.fill",
                                                          withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
                }
                if let barChartVC = controller as? BarGraphStatistics {
                    barChartVC.tabBarItem.image = UIImage(systemName: "chart.bar.fill",
                                                          withConfiguration: UIImage.SymbolConfiguration(weight: .thin))
                }
                if let archiveVC = controller as? ArchivePurposeTableViewController {
                    archiveVC.tabBarItem.image = UIImage(systemName: "archivebox.fill",
                                                         withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
                }
            }
        }
    }
    
}
