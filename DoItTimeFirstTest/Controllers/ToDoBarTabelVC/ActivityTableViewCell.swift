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
    var cellIndex: Int?
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
        
    @IBAction func startTimeButton() {
        startButton.isHidden = true
        stopButton.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        //timer?.isValid
        CoreDataManager.shared.saveStartDate(objectTime[cellIndex!], date: Date())
    }
    
    @objc func updateTimer() { timerCount += 1 }
    
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
        
        CoreDataManager.shared.updateTime(objectTime[cellIndex!], newTime: timerCount)
        
        CoreDataManager.shared.deleteStartDate(objectTime[cellIndex!])
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
}

extension ActivityTableViewCell {
    func getStartTimeForIndex() {
          let calendar = Calendar.current
          
          for objeckt in objectTime {
              if objeckt.startDate != nil {
                  let test = calendar.dateComponents([.day, .hour, .minute, .second],
                                                     from: objeckt.startDate!,
                                                     to: Date())
                  let awakeTime = calculationOfAmount(test.day, test.hour, test.minute, test.second)
                  timerCount = Int64(awakeTime)
                print(awakeTime)
              }
          }
      }
    private func calculationOfAmount(_ day: Int?, _ hour: Int?, _ minute: Int?, _ second: Int?) -> Int {
        var summ = 0
        
        if day != 0 { summ += day! * 86400 }
        if hour != 0 { summ += hour! * 3600 }
        if minute != 0 { summ += minute! * 60 }
        summ += second!
        
        return summ
    }
}
