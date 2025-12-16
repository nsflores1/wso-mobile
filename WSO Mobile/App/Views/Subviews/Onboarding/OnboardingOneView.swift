//
//  OnboardingOneView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct OnboardingOneView: View {
    var body: some View {
        NavigationStack {
                VStack {
                    let mainText = """
                You're testing WSO Mobile Beta v1.2.1.
                
                This app is in a preliminary state. Your feedback matters a lot! If you run into any issues, please report them as soon as possible.
                
                How do you send feedback? Simple! Use TestFlight, the Beta GroupMe, or DM @wsogram on Instagram.
                
                The next pages will tell you some important things to keep in mind when sending feedback, and about the beta in general.
                
                Swipe to the left to view the next page!
                """
                    Text(mainText)
                        .multilineTextAlignment(.leading)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                }.padding(20)
                .navigationTitle(Text("Welcome to WSO Beta!"))
        }.padding(20)
    }
}

#Preview {
    OnboardingOneView()
}
