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
    @AppStorage("surferErrors") private var surferErrors: Bool = false
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

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // TODO: rewrite this when Apple releases a less awful way of doing bindings in non-closure environments
                    Toggle("Enable Notifications", isOn: Binding(get: { notificationManager.isAuthorized}, set: { _ in }))
                        .disabled(true)
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
                    }
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                    if whimsyEnabled {
                        Toggle("Mathematical Mode", isOn: $likesMath)
                            .simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            })
                        Toggle("Surfer Errors on Login", isOn: $surferErrors)
                            .simultaneousGesture(TapGesture().onEnded {
                                Task {
                                    if surferErrors {
                                        await notificationManager.scheduleLocal(
                                            title: "Hit the beach!",
                                            body: "Gnarly, dude! Let's hope you don't wipeout on login!",
                                            date: Date().addingTimeInterval(1)
                                        )
                                    } else if !surferErrors {
                                        await notificationManager.scheduleLocal(
                                            title: "Surf's up!",
                                            body: "(You hear the sound of a surfboard being put away.)",
                                            date: Date().addingTimeInterval(1)
                                        )

                                    }
                                }
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            })
                    }
                    Toggle("Use Serif Font For Record", isOn: $likesSerifFont)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                    Toggle("Enable Beta Options", isOn: $betaOptionsEnabled)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                } header : {
                    Text("Toggles")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Toggle("Show Dining Menus", isOn: $diningIsShown)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
                    Toggle("Show News Reader", isOn: $newsIsShown)
                        .simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        })
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
                            .simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            })
                        Text("See menus up to one week into the future. May be inaccurate. May not work.").italic()
                        Toggle("Enable whimsy", isOn: $whimsyEnabled)
                            .simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                            })
                        Text("Adds back some beta-exclusive \"features\" (mostly bad jokes) which were left out during the app's public release.").italic()
                        if whimsyEnabled {
                            // EASTER EGG
                            Button {
                                secretEnabled.toggle()
                                Task {
                                    if secretEnabled {
                                        logger.trace("User has enabled the easter egg")
                                        await notificationManager.scheduleLocal(
                                            title: "綺麗な星空を眺める",
                                            body: "「ABOUT」と言うページを見たらいいと思うよ",
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
                                        Text("エフェリア君の内緒を聞く...")
                                        Text("Hear Ephelia's secret...")
                                            .font(.caption)
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("星の動きを観察する")
                                Text("Observe the motion of the stars")
                                    .font(.caption)
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
