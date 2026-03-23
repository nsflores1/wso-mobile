//
//  WSOMobileApp.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI
import Logging

// these are global constants! change them on updates.
let appVersion = "v1.5.1"
let appVersionName = "Delicious Dining"

private struct LoggerKey: EnvironmentKey {
    static let defaultValue = Logger(label: "com.wso.WSO-Mobile")
}

extension EnvironmentValues {
    var logger: Logger {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }
}

@main
struct WSOMobileApp: App {
    // declare all state managers here
    @State private var authManager = AuthManager.shared
    @State private var cacheManager = CacheManager.shared
    @State private var notifsManager = NotificationManager.shared

    let logger: Logger

    init() {
        let logFileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("app.log")
        // nuke the log every boot
        try? FileManager.default.removeItem(at: logFileURL)

        LoggingSystem.bootstrap { label in
             var handler = MultiplexLogHandler(handlers: [
                StreamLogHandler.standardOutput(label: label), // xcode console
                FileLogHandler(label: label, fileURL: logFileURL)
            ])
            #if DEBUG
            handler.logLevel = .debug // everything
            #else
            handler.logLevel = .debug // change if needed, .debug is perf hit!
            #endif
            return handler
        }

        // the core logger, now that we've bootstrapped
        self.logger = Logger(label: "com.wso.main")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(notifsManager)
                .environment(cacheManager)
                .environment(\.logger, logger)
        }
    }
}
