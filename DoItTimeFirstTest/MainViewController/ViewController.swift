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
        for button in cornerRadiusButtons {
            button.layer.cornerRadius = button.frame.width / 2
        }
    }
}
