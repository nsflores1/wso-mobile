//
//  SettingsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-13.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("likesMath") var likesMath: Bool = false
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    @State private var notificationManager = NotificationManager.shared
    

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("Enable Notifications", isOn: $notificationManager.isAuthorized)
                        .disabled(true)
                        .task {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            _ = await notificationManager.requestPermission()
                        }
                    if !notificationManager.isAuthorized {
                        Button("Enable in Settings...") {
                            Task {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                _ = await notificationManager.requestPermission()
                            }
                        }
                    }
                    Button("Test Notifications") {
                        Task {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            await notificationManager.scheduleLocal(
                                title: "Hurray!",
                                body: "Notifications actually work now!",
                                date: Date().addingTimeInterval(1)
                            )
                        }
                    }
                    // TODO: implement a notification for upcoming record releases
                    // TODO: implement HasSalmon
                } header : {
                    Text("Notifications")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Toggle("Mathematical Mode", isOn: $likesMath)
                        .sensoryFeedback(.selection, trigger: likesMath)
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        .sensoryFeedback(.selection, trigger: hatesEatingOut)
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Button("Reset Onboarding") {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        hasSeenOnboarding.toggle()
                    }.sensoryFeedback(.selection, trigger: hatesEatingOut)
                    Button("Force Clear Cache") {
                        Task {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            URLCache.shared.removeAllCachedResponses()
                            await notificationManager.scheduleLocal(
                                title: "Cache cleared!",
                                body: "Please restart the app.",
                                date: Date().addingTimeInterval(1)
                            )
                        }
                    }
                } header : {
                    Text("Reset & Cache")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
            .navigationTitle("Settings")
            .modifier(NavSubtitleIfAvailable(subtitle: "App settings may require a restart"))
        }
    }
}

#Preview {
    SettingsView()
}
