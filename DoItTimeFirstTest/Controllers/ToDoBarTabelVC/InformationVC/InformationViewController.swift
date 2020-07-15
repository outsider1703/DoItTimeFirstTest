//
//  InformationViewController.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 08.07.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    
    var swipeCellInfo: Purpose!
    
    @IBOutlet var testNameInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testNameInfoLabel.text = String(swipeCellInfo.time)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
