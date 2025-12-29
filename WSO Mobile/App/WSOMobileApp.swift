//
//  WSO_MobileApp.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI
import Logging

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

        // truncate the log and rotate it
        // TODO: clean this up later
//        if let attrs = try? FileManager.default.attributesOfItem(atPath: logFileURL.path),
//           let size = attrs[.size] as? UInt64, size > 5_000_000 { // 5mb
//            let archived = logFileURL.deletingLastPathComponent()
//                .appendingPathComponent("app-\(Date().timeIntervalSince1970).log")
//            try? FileManager.default.moveItem(at: logFileURL, to: archived)
//        }
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
