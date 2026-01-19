//
//  OnboardingView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

// Users will see this EXACTLY ONCE, but can
// reset their app to see it multiple times if they want.

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage: Int = 0

    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingOneView().tag(0)
            OnboardingTwoView().tag(1)
            OnboardingThreeView().tag(2)
            OnboardingFourView().tag(3)
            OnboardingFiveView().tag(4)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingView()
}
