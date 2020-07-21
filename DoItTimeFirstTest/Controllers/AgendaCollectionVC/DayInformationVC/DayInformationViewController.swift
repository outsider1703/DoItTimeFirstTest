//
//  DayInformationViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 10.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class DayInformationViewController: UIViewController {
    
    @IBOutlet var testLabel: UILabel!
    let date = Date()
    let calendar = Calendar.current
    let dateFormat = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormat.dateFormat = "d"
        testLabel.text = dateFormat.string(from: date)
    }
}
