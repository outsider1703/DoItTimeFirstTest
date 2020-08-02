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
    
   private var objectTime: [Purpose]!
    
   private var timer: Timer?
   private var cellIndex: Int?
   private var timerCount: Int64 = 0 {
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

    @IBAction func startTimeButton() {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        startTimer()

        CoreDataManager.shared.saveStartDate(objectTime[cellIndex!])
    }
        
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
        
        CoreDataManager.shared.updateTime(objectTime[cellIndex!], newTime: timerCount)
        
        CoreDataManager.shared.deleteStartDate(objectTime[cellIndex!])
        CoreDataManager.shared.deleteStartTime(objectTime[cellIndex!])
        timer?.invalidate()
        timer = nil
        timerCount = 0
    }
}

extension ActivityTableViewCell {
    
    func prepareNameForCell(text: String?) {
        nameActivityLabel.text = text
    }
    
    func prepareIndexForTag(indexPath: Int) {
        cellIndex = indexPath
    }
    
    func setAwakeTimes(timeCount: Int64) {
        timerCount = timeCount
        if timeCount > 0 {
        startButton.isHidden = true
        stopButton.isHidden = false
        startTimer()
        }
    }
}
extension ActivityTableViewCell {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)

    }
    @objc func updateTimer() { timerCount += 1 }

    
    
}
