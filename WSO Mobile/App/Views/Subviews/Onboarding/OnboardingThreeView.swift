//
//  OnboardingThreeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct OnboardingThreeView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                let mainText = """
                    Please submit feedback in a timely manner; new Beta versions are always coming out and so we are always changing things. It is possible whatever issue you have has already been resolved in a newer version.
                    
                    So make sure to update to the latest version before submitting feedback.
                    
                    Thanks again for testing out the app!
                    
                    If you want to see any of this text again, change the setting in the app to see it again.
                    """
                Text(mainText)
            }.padding(20)
            Spacer()
            VStack {
                Text("Ready to go!")
                Button("Get started") {
                    hasSeenOnboarding = true
                }
                .buttonStyle(.borderedProminent)
            }
            Spacer()
            .navigationTitle(Text("One More Thing"))
        }.padding(20)
    }
}


#Preview {
    OnboardingThreeView()
}
