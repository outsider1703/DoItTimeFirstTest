//
//  ActivityTableViewCell.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 05.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
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
    }
    
    @IBAction func stopTimeButton() {
        stopButton.isHidden = true
        startButton.isHidden = false
    }
}
