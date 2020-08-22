//
//  SceneDelegate.swift
//  DoItTimeFirstTest
//
//  Created by Macbook on 29.06.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
//    var sleepTime: Int64?
//    var sleepDate: Date?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
//        let toDoTableVC = ToDoBarTableViewController()
//        toDoTableVC.view.reloadInputViews()
//
//        let awakeTime = -Int(sleepDate?.timeIntervalSinceNow ?? 0)
//        if awakeTime != 0 {
//        let activityVC = ActivityTableViewCell()
//        print(awakeTime)
//        activityVC.prepareSleep(time: Int64(awakeTime))
//        }
    }
//    
//    func sceneDidEnterBackground(_ scene: UIScene) {
//        sleepDate = Date()
//    }
}

