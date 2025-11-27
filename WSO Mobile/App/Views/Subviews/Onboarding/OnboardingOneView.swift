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
            VStack
            {
                Text("Welcome to the WSO Mobile beta test!")
                    .bold()
                    .italic(true)

                Text(verbatim: "\nVersion: v(0.0.1)")
                    .font(.subheadline)
                let mainText = """
                
                This app is in a preliminary state. Your feedback matters a lot! If you run into any issues, please report them as soon as possible.
                
                How do you send feedback? Simple! Just contact me (Nathaniel Flores):
                - Use the GroupMe for WSO beta testers
                - DM me on Instagram: @n_s_flores
                - Send an email to nsf1@williams.edu
                
                The next pages will tell you some important things to keep in mind when sending feedback.
                
                Swipe to the left to view the next page!
                """
                Text(mainText)
                    .multilineTextAlignment(.leading)
                Spacer()
            }.padding(20)
                .navigationTitle(Text("Welcome to the Beta!"))
        }.padding(20)
    }
}

#Preview {
    OnboardingOneView()
}
