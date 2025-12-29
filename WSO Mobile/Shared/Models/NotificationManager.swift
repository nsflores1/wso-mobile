//
//  NotificationManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

// meta-class that handles all notifications everywhere,
// also handles local and remote notifications.

import UserNotifications
import Logging
import SwiftUI

@available(macOS 14.0, *)
extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound, .badge]
    }
}

@available(macOS 14.0, *)
@MainActor
@Observable
class NotificationManager: NSObject {
    fileprivate let logger = Logger(label: "com.wso.NotificationManager")
    static let shared = NotificationManager()

    var isAuthorized = false
    private let center = UNUserNotificationCenter.current()

    override init() {
        super.init()
        center.delegate = self
    }

    func requestPermission() async -> Bool {
        do {
            isAuthorized = try await center.requestAuthorization(options: [.badge, .alert, .sound])
            return isAuthorized
        } catch {
            return false
        }
    }

    func scheduleLocal(title: String, body: String, date: Date, identifier: String? = nil) async {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = Calendar.current.dateComponents([
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let id = identifier ?? UUID().uuidString

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        logger.trace("New notification scheduled: \(request)")
        try? await center.add(request)
    }

    func scheduleRemote() {
        // TODO: this is a stub that does nothing.
        // When you want to add remote support,
        // fill this in!
    }

    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}
