//
//  ActivityTableViewCell.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 05.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    var timer: Timer?
    var timerCount = 0
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameActivityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func startTimeButton() {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
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
    
    
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
        
        timer?.invalidate()
        timer = nil
        timerCount = 0
        timeLabel.text = "0"
    }
}
