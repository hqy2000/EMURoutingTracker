//
//  AppDelegate.swift
//  chinaemu
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import UIKit
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "moe.hqy.chinaemu.push", using: nil) { task in
//            print("Refresh")
//            dump(task)
//             self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
//        self.scheduleAppRefresh()
        
        return true
    }
    
//    func scheduleAppRefresh() {
//       let request = BGAppRefreshTaskRequest(identifier: "moe.hqy.chinaemu.push")
//       // Fetch no earlier than 15 minutes from now
//       request.earliestBeginDate = Date(timeIntervalSinceNow: 30)
//            
//       do {
//          try BGTaskScheduler.shared.submit(request)
//       } catch {
//          print("Could not schedule app refresh: \(error)")
//       }
//    }
//    
//    func handleAppRefresh(task: BGAppRefreshTask) {
//        // Schedule a new refresh task
//        scheduleAppRefresh()
//        
//        let content = UNMutableNotificationContent()
//        content.title = "G2已发车"
//        content.body = "使用车组：CRH2A2001"
//        let notification = UNNotificationRequest(identifier: "push", content: content, trigger: nil)
//        UNUserNotificationCenter.current().add(notification) { (error) in
//            print(error)
//        }
//        task.setTaskCompleted(success: true)
//     }

}
