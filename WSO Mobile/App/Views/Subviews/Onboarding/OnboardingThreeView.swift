//
//  OnboardingThreeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI
import Shimmer

struct OnboardingThreeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
                    WSO Mobile is constantly under development and is not complete yet.
                    
                    Features which are still not implemented in this version include:
                    - FacTrak
                    - DormTrak
                    - ClubTrak
                    - Discussions
                    - EphMatch
                    - Posting content
                    - Dining notifications
                    
                    All other features not listed here are implemented in-app. If you would like to see the above features implemented, please send feedback to WSO via the form located in the \"More\" tab of the app.
                    """)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                Text("Swipe to the left to continue.")
                    .shimmering()
                    .padding(5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .navigationTitle(Text("Known Issues"))
        }.padding(20)
    }
}

#Preview {
    OnboardingThreeView()
}
