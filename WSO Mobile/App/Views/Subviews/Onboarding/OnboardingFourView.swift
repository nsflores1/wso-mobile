//
//  OnboardingFourView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI
import Shimmer

struct OnboardingFourView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
                    WSO Mobile requires agreeing to the software license and to the privacy policy to use the app. Please read the contents before using the app. By using the app, you consent to following the rules stated within them. You may find them in the \"More\" tab.
                    
                    Some other things you may want to know:
                    
                    - You can swipe left on many list items to get additional options, such as sharing them and opening their links.
                    - Quickly email WSO users by clicking on their Unix in Facebook. View their hometowns by clicking on them in the profile options menu.
                    - WSO Mobile ships with widgets! Add them to your homescreen to see data at a glance, without opening the app.
                    """)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                Text("Swipe to the left to continue; please read the license and policy after starting the app.")
                    .shimmering()
                    .padding(5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .navigationTitle(Text("Final Notes"))
        }.padding(20)
    }
}

#Preview {
    OnboardingFourView()
}
