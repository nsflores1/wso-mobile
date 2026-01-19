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
                Text("WSO Mobile requires agreeing to a software license to use the app. Please read the contents before using the app.")
                    .padding(20)
                    .multilineTextAlignment(.leading)
                SoftwareLicenseTextView()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                Text("Swipe to the left to agree to the policy.")
                    .shimmering()
                    .padding(5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .navigationTitle(Text("Software License"))
        }.padding(20)
    }
}

#Preview {
    OnboardingFourView()
}
