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

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Mathematical Mode", isOn: $likesMath)
                        // TODO: test if this works on device
                        .sensoryFeedback(.selection, trigger: likesMath)
                    Toggle("Hide All Restaurants", isOn: $hatesEatingOut)
                        // TODO: test if this works on device
                        .sensoryFeedback(.selection, trigger: hatesEatingOut)
                    Button("Reset Onboarding") {
                        hasSeenOnboarding.toggle()
                    }
                        // TODO: test if this works on device
                        .sensoryFeedback(.selection, trigger: hatesEatingOut)
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
