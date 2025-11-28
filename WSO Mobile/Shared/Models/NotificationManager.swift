//
//  NotificationManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-28.
//

// meta-class that handles all notifications everywhere,
// also handles local and remote notifications.

import UserNotifications
import Combine

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized = false
    private let center = UNUserNotificationCenter.current()

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
        ], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let id = identifier ?? UUID().uuidString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

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
