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
                let mainText = """
                You're using WSO Mobile Beta v1.2.2.
                
                WSO (Williams Students Online) is a student organization at Williams College devoted to making software to help the college community, and this is our app!
                
                In the following pages, you will get information on how to use the app and set up some basic settings.
                
                Swipe to the left to view the next page!
                """
                Text(mainText)
                .padding(20)
                .multilineTextAlignment(.leading)
                .navigationTitle(Text("Welcome!"))
                Spacer()
        }.padding(20)
    }
}

#Preview {
    OnboardingOneView()
}
