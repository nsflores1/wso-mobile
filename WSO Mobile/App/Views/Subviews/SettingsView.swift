//
//  SettingsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-13.
//

import SwiftUI
import Kingfisher
import Logging

struct SettingsView: View {
    @Environment(\.logger) private var logger
    @AppStorage("likesMath") var likesMath: Bool = false
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("likesSerifFont") private var likesSerifFont: Bool = false

    @AppStorage("userType") private var userType: UserType = .student

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
                                logger.info("User has attempted to enable notifications, waiting...")
                                let status = await notificationManager.requestPermission()
                                if status {
                                    logger.info("User has enabled notifications")
                                } else {
                                    logger.info("User did not enable notifications")
                                }
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            }
                        }
                    }
                    Button("Test Notifications") {
                        Task {
                            logger.info("User has tested notifications")
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
                    Picker("User Type", selection: $userType) {
                        Text("Student").tag(UserType.student)
                        Text("Non-student").tag(UserType.nonstudent)
                    }
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
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
                        logger.info("User has reset onboarding state")
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
                            logger.info("Cache forcibly reset")
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        }
                    }
                    if userType == .student {
                        Button("Logout of WSO") {
                            Task {
                                authManager.logout()
                                logger.info("User has logged out")
                                await notificationManager.scheduleLocal(
                                    title: "Logout complete!",
                                    body: "Please restart the app.",
                                    date: Date().addingTimeInterval(1)
                                )
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }
                        }
                    }
                    NavigationLink(destination: LogViewerView()) {
                        Text("View Debug Log")
                    }
                } header : {
                    Text("Reset & Cache")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
            .navigationTitle("Settings")
            .modifier(NavSubtitleIfAvailable(subtitle: "App settings may require a restart"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: SettingsKeyView()) {
                            Image(systemName: "questionmark")
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
