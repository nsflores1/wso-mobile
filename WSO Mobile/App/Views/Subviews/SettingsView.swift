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
                            _ = await notificationManager.requestPermission()
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }
                    if !notificationManager.isAuthorized {
                        Button("Enable in Settings...") {
                            Task {
                                _ = await notificationManager.requestPermission()
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            }
                        }
                    }
                    Button("Test Notifications") {
                        Task {
                            await notificationManager.scheduleLocal(
                                title: "Hurray!",
                                body: "Notifications actually work now!",
                                date: Date().addingTimeInterval(1)
                            )
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
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
                        .simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    })
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Button("Reset Onboarding") {
                        hasSeenOnboarding.toggle()
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    }.sensoryFeedback(.selection, trigger: hatesEatingOut)
                    Button("Force Clear Cache") {
                        Task {
                            URLCache.shared.removeAllCachedResponses()
                            await notificationManager.scheduleLocal(
                                title: "Cache cleared!",
                                body: "Please restart the app.",
                                date: Date().addingTimeInterval(1)
                            )
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
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
