//
//  WSO_MobileApp.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI

@main
struct WSOMobileApp: App {
    // declare all state managers here
    @State private var authManager = AuthManager.shared
    @State private var cacheManager = CacheManager.shared
    @State private var notifsManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(notifsManager)
                .environment(cacheManager)
        }
    }
}
