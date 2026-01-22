//
//  OnboardingOneView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Shimmer

struct OnboardingOneView: View {
    var body: some View {
        NavigationStack {
            VStack {
                let mainText = """
                You're using:
                WSO Mobile Rewritten, v1.3.0
                
                WSO (Williams Students Online) is a student organization at Williams College devoted to making software to help the college community, and this is our app! It provides a variety of useful services for students, faculty, staff, alumni, and all who are interested in Williams College or part of its community.
                
                In the following pages, you will get information on how to use the app and you will configure some basic settings.
                """
                let secondaryText = """
                Swipe to the left to view the next page!
                """
                Text(mainText)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                Text(secondaryText)
                    .shimmering()
                    .padding(5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .navigationTitle(Text("Welcome!"))
        }.padding(20)
    }
}

#Preview {
    OnboardingOneView()
}
