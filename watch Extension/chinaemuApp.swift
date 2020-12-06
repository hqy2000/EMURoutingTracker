//
//  chinaemuApp.swift
//  watch Extension
//
//  Created by Qingyang Hu on 11/22/20.
//

import SwiftUI

@main
struct chinaemuApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
