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
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @AppStorage("likesSerifFont") private var likesSerifFont: Bool = false

    @AppStorage("betaOptionsEnabled") private var betaOptionsEnabled: Bool = false
    @AppStorage("betaFutureMenusEnabled") private var betaFutureMenusEnabled: Bool = false

    // easter egg
    @AppStorage("whimsyEnabled") private var whimsyEnabled: Bool = false
    @AppStorage("secretEnabled") private var secretEnabled: Bool = false

    @AppStorage("userType") private var userType: UserType = .student

    // user toggles
    @AppStorage("newsIsShown") private var newsIsShown: Bool = true
    @AppStorage("wcfmIsShown") private var wcfmIsShown: Bool = true
    @AppStorage("diningIsShown") private var diningIsShown: Bool = true

    @Environment(NotificationManager.self) private var notificationManager
    @Environment(AuthManager.self) private var authManager
    @Environment(\.openURL) private var openURL

    private let cache = CacheManager.shared
    private let application = UIApplication.shared

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // TODO: rewrite this when Apple releases a less awful way of doing bindings in non-closure environments
                    Toggle("Enable Notifications", isOn: Binding(get: { notificationManager.isAuthorized }, set: { _ in }))
                        .disabled(true)
                        .onAppear {
                            Task {
                                let status = await notificationManager.requestPermission()
                                if status {
                                    notificationManager.isAuthorized = true
                                } else {
                                    notificationManager.isAuthorized = false
                                }
                            }
                        }
                    if !notificationManager.isAuthorized {
                        Button("Enable in Settings...") {
                            Task {
                                logger.trace("User has attempted to enable notifications, waiting...")
                                let status = await notificationManager.requestPermission()
                                if status {
                                    logger.info("User has enabled notifications")
                                } else {
                                    logger.error("User did not enable notifications")
                                }
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            }
                        }
                    }
                    Button("Test Notifications") {
                        Task {
                            logger.trace("User has tested notifications")
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
                    }.hapticTap(.rigid)
                    Toggle("Use Serif Font For Record", isOn: $likesSerifFont)
                        .hapticTap(.rigid)
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        .hapticTap(.rigid)
                    Toggle("Enable Beta Options", isOn: $betaOptionsEnabled)
                        .hapticTap(.rigid)
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Toggle("Show Dining Menus", isOn: $diningIsShown)
                        .hapticTap(.rigid)
                    Toggle("Show News Reader", isOn: $newsIsShown)
                        .hapticTap(.rigid)
                    Toggle("Show WCFM Player", isOn: $wcfmIsShown)
                        .simultaneousGesture(TapGesture().onEnded {
                            Task {
                                if !wcfmIsShown && whimsyEnabled {
                                    await notificationManager.scheduleLocal(
                                        title: ":(",
                                        body: "I worked hard on that player, you know...",
                                        date: Date().addingTimeInterval(1)
                                    )
                                } else if wcfmIsShown && whimsyEnabled {
                                    await notificationManager.scheduleLocal(
                                        title: ":)",
                                        body: "Enjoy the music!!!",
                                        date: Date().addingTimeInterval(1)
                                    )
                                }
                            }
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                } header : {
                    Text("Show Sections")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Button("Reset Onboarding") {
                        hasSeenOnboarding.toggle()
                        logger.trace("User has reset onboarding state")
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
                        Button("Force Refresh Token") {
                            Task {
                                let _  = try await authManager.refreshToken()
                                logger.trace("User has deleted token")
                                await notificationManager.scheduleLocal(
                                    title: "Refresh complete!",
                                    body: "Please restart the app.",
                                    date: Date().addingTimeInterval(1)
                                )
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }
                        }
                        Button("Logout of WSO") {
                            Task {
                                authManager.wipeAppKeychain()
                                authManager.logout()
                                logger.trace("User has logged out")
                                await notificationManager.scheduleLocal(
                                    title: "Logout complete!",
                                    body: "Please restart the app.",
                                    date: Date().addingTimeInterval(1)
                                )
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }
                        }
                    }
                } header : {
                    Text("Reset & Cache")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                if betaOptionsEnabled {
                    Section {
                        Text("""
                        Using these may crash your app or show you things you shouldn't see. Use with caution.
                        
                        The WSO development team makes NO guarantees as to beta feature functionality and may remove them at any time.
                        """)
                        NavigationLink(destination: LogViewerView()) {
                            Text("View Debug Log")
                        }
                        Toggle("Enable Future Menus", isOn: $betaFutureMenusEnabled)
                            .hapticTap(.rigid)
                        Text("See menus up to one week into the future. May be inaccurate. May not work.").italic()
                        Toggle("Enable whimsy", isOn: $whimsyEnabled)
                            .hapticTap(.rigid)
                        Text("Adds back some beta-exclusive \"features\" (mostly bad jokes) which were left out during the app's public release.").italic()
                        if whimsyEnabled {
                            // EASTER EGG
                            Button {
                                secretEnabled.toggle()
                                Task {
                                    if secretEnabled {
                                        await notificationManager.scheduleLocal(
                                            title: "The motion of the stars",
                                            body: "I hear good things await you on the ABOUT page.",
                                            date: Date().addingTimeInterval(1)
                                        )
                                    }
                                }
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            } label: {
                                HStack {
                                    if secretEnabled {
                                        Text("🐮")
                                    }
                                    VStack(alignment: .leading) {
                                        Text("Hear Ephelia's secret...")
                                    }
                                }
                            }
                        }
                        // rickroll people who think this would actually work. deserved
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            openURL(URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!)
                        } label: {
                            Text("Ban WSO Users...")
                        }
                    } header : {
                        VStack {
                            Text("Experimental (Beta) Options")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .modifier(NavSubtitleIfAvailable(subtitle: "App settings may require a restart"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: SettingsKeyView()) {
                            Image(systemName: "questionmark")
                        }.hapticTap(.rigid)
                    }
                }
            }
        }
    }
}

struct SettingsKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                let explanation = """
                    This page is a short explanation on what the various settings do.
                    
                    Each group of settings is listed below with an explanation per setting:
                    """
                Text(explanation)
                Section {
                    HStack {
                        Text("Enable Notifications: ").bold() + Text("allows you to recieve notifications. If you have disabled notifications for WSO, you will need to enable them in the Settings app on your phone.")
                    }
                    HStack {
                        Text("Test Notifications: ").bold() + Text("sends a test notification. It may not deliver if you are using a Focus mode, such as Do Not Disturb.")
                    }
                } header : {
                    Text("Notifications")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    HStack {
                        Text("User Type: ").bold() + Text("this setting allows non-students to hide/disable interface items which would require a student login.")
                    }
                    HStack {
                        Text("Use Serif Font For Record: ").bold() + Text("changes the font used in the in-app Williams Record reader to the same serif font used in the physical newsprint version (the default is a sans serif font).")
                    }
                    HStack {
                        Text("Hide All Restaurants: ").bold() + Text("hides all non-dining halls from the Dining tab of the app.")
                    }
                    HStack {
                        Text("Enable Beta Options: ").bold() + Text("does exactly what it says it does. If you are a WSO developer or just curious about new features, you can use this to test new features that are not yet available to the general public.")
                    }
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    HStack {
                        Text("Reset Onboarding: ").bold() + Text("resets the onboarding flow to its original state, if you want to read it again.")
                    }
                    HStack {
                        Text("Force Clear Cache: ").bold() + Text("this button deletes all temporary files that WSO uses on disk except for your login data.")
                    }
                    HStack {
                        Text("Logout of WSO: ").bold() + Text("resets your login. Only visible to students (since only students can login).")
                    }
                } header : {
                    Text("Reset & Cache")
                        .fontWeight(.semibold)
                        .font(.title3)
                }

            }
            .navigationTitle("Settings Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your settings-related questions"))
        }
    }
}

#Preview {
    SettingsView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
