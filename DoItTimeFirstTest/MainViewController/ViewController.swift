//
//  ViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 29.06.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer?
    var timerCount = 0
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var cornerRadiusButtons: [UIButton]!
    @IBOutlet var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.layer.cornerRadius = 15
        settingCornerRadiusForButtons()
    }
    @IBAction func startTimeButton(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopTimerButton(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        timerCount = 0
        timeLabel.text = "0"
    }
    
    @objc func updateTimer() {
        timerCount += 1
        
        let minuts = timerCount / 60
        
        
        if timerCount < 60 {
            timeLabel.text = String(timerCount)
        } else {
            timeLabel.text = "\(minuts):\(timerCount % 60)"
        }
    }
}



extension ViewController {
    private func settingCornerRadiusForButtons() {
        for button in cornerRadiusButtons {
            button.layer.cornerRadius = button.frame.width / 2
        }
        startButton.layer.cornerRadius = startButton.frame.width / 2
    }
}
