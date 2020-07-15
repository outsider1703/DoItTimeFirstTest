//
//  ActivityTableViewCell.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 05.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var stopButton: UIButton!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var nameActivityLabel: UILabel!
    
    var objectTime: [Purpose]!
    var timer: Timer?
    var timerCount: Int64 = 0 {
        didSet {
            if timerCount < 60 {
                timeLabel.text = String(timerCount)
            } else {
                let minuts = timerCount / 60
                timeLabel.text = "\(minuts):\(timerCount % 60)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        objectTime = CoreDataManager.shared.fetchData()
        
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    override func prepareForReuse() {
        nameActivityLabel.text = nil
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
    }
    
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
        
        CoreDataManager.shared.updateTime(objectTime[startButton.tag], newTime: timerCount)
        
        timer?.invalidate()
        timer = nil
        timerCount = 0     }
}


extension ActivityTableViewCell {
    
    func prepareNameForCell(text: String?) {
        nameActivityLabel.text = text
    }
    
   func prepareIndexForTag(index: Int) {
        startButton.tag = index
    }

}
