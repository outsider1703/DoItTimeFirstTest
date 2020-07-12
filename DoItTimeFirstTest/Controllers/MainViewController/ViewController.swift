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
}
