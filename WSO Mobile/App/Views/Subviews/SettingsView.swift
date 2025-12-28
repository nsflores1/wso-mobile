//
//  SettingsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-13.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    @AppStorage("likesMath") var likesMath: Bool = false
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("likesSerifFont") private var likesSerifFont: Bool = false

    @Environment(NotificationManager.self) private var notificationManager
    @Environment(AuthManager.self) private var authManager

    private let cache = CacheManager.shared

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // TODO: rewrite this when Apple releases a less awful way of doing bindings in non-closure environments
                    Toggle("Enable Notifications", isOn: Binding(get: { notificationManager.isAuthorized}, set: { _ in }))
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
                    Toggle("Use Serif Font For Record", isOn: $likesSerifFont)
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
                            // URL requests
                            URLCache.shared.removeAllCachedResponses()
                            // Kingfisher Image Data
                            ImageCache.default.clearMemoryCache()
                            await ImageCache.default.clearDiskCache()
                            // on disk cache
                            await cache.clear()
                            // we're done!
                            await notificationManager.scheduleLocal(
                                title: "Cache cleared!",
                                body: "Please restart the app.",
                                date: Date().addingTimeInterval(1)
                            )
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        }
                    }
                    Button("Logout of WSO") {
                        Task {
                            authManager.logout()
                            await notificationManager.scheduleLocal(
                                title: "Logout complete!",
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
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
