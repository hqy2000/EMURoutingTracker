//
//  AppDelegate.swift
//  EMURoutingTracker
//
//  Created by Qingyang Hu on 11/10/20.
//

import Foundation
import UIKit
import BackgroundTasks
import Sentry

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UserDefaultsMigrater.migrate()
        SentrySDK.start { options in
            options.dsn = "https://85987290d32948b7a5434c6604a8d283@sentry.io/1545955"
        }
        return true
    }
}
