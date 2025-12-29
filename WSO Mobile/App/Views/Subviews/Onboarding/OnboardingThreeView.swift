//
//  OnboardingThreeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Shimmer

struct OnboardingThreeView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                let mainText = """
                    If you find any bugs with the app, please let us know by contacting us. You can do this from the forms on the Links tab of the app.
                    
                    WSO Mobile is always improving, so please be sure to update your app and clear caches before submitting feedback; it's possible that we have already removed a bug in the latest update!
                    
                    Thanks again for using the app!
                    
                    If you want to see any of this text again, change the setting in the app to reset your onboarding progress.
                    """
                Text(mainText)
            }.padding(20)
            Spacer()
            VStack {
                Text("Ready to go!")
                    .shimmering()
                Button("Get started") {
                    hasSeenOnboarding = true
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
            .navigationTitle(Text("Complete!"))
        }.padding(20)
    }
}


#Preview {
    OnboardingThreeView()
}
