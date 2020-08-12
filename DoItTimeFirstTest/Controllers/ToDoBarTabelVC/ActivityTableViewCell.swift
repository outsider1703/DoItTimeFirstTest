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
    @IBOutlet private var timeLabel: UILabel?
    @IBOutlet  var nameActivityLabel: UILabel?
    
    private var personalCell: Purpose!
    
    private var timer: Timer?
    private var timerCount: Int64 = 0 {
        didSet {
            if timerCount < 60 {
                timeLabel?.text = String(timerCount)
            } else {
                let minuts = timerCount / 60
                timeLabel?.text = "\(minuts):\(timerCount % 60)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        startButton.isHidden = false
        stopButton.isHidden = true
        timerCount = 0
        nameActivityLabel?.text = nil
    }
    
    @IBAction func startTimeButton() {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        startTimer()
        
        CoreDataManager.shared.saveStartDate(personalCell)
    }
    
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
        
        CoreDataManager.shared.updateTime(personalCell, newTime: timerCount)
        
        CoreDataManager.shared.deleteStartDate(personalCell)
        CoreDataManager.shared.deleteStartTime(personalCell)
        timer?.invalidate()
        timer = nil
        timerCount = 0
    }
}
//MARK: - Private Func
extension ActivityTableViewCell {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    @objc func updateTimer() { timerCount += 1 }
    
   private func setAwakeTimes(timeCount: Int64) {
        timerCount = timeCount
        if timeCount > 0 {
            startButton.isHidden = true
            stopButton.isHidden = false
            startTimer()
        }
    }
}
//MARK: - Public Func
extension ActivityTableViewCell {
    
    func preparePersonalCell(_ task: Purpose) {
        personalCell = task
        nameActivityLabel?.text = task.name
        setAwakeTimes(timeCount: task.startTime)
    }
}
