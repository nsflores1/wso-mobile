//
//  ProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("likesMath") var likesMath: Bool = false
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    @StateObject private var notificationManager = NotificationManager.shared

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Mathematical Mode", isOn: $likesMath)
                        .sensoryFeedback(.selection, trigger: likesMath)
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        .sensoryFeedback(.selection, trigger: hatesEatingOut)
                    Toggle("Enable Notifications", isOn: $notificationManager.isAuthorized)
                        .disabled(true)
                        .task {
                            _ = await notificationManager.requestPermission()
                        }
                    if !notificationManager.isAuthorized {
                        Button("Enable in Settings...") {
                            Task {
                                await notificationManager.requestPermission()
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
                        }
                    }
                    Button("Reset Onboarding") {
                        hasSeenOnboarding.toggle()
                    }.sensoryFeedback(.selection, trigger: hatesEatingOut)

                } header : {
                    Text("Settings")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                ImportantLinksView()
            }
            .listStyle(.grouped)
            .navigationTitle(Text("More"))
            .navigationSubtitle(Text("WSO Mobile version: v0.0.1"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView()
}
