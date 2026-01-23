//
//  OnboardingTwoView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Shimmer

struct OnboardingTwoView: View {
    @AppStorage("userType") private var userType: UserType = .student
    
    var body: some View {
        NavigationStack {
            VStack {
                let mainText = """
                WSO Mobile is designed to be usable by both students and non-students; however, non-students will have some features disabled, as some of the app's features require a login to the service.
                
                For the best possible user experience, please select the option that best represents you:
                """
                let secondaryText = """
                (You can always change this later in the Settings menu.)
                """
                Text(mainText)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                VStack {
                    Text("Select a user type:")
                        .italic()
                        .shimmering()
                    Picker("User Type", selection: $userType) {
                        Text("Student").tag(UserType.student)
                        Text("Non-student").tag(UserType.nonstudent)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                    })
                }
                Text(secondaryText)
                    .padding(20)
                    .multilineTextAlignment(.leading)
                Text("Swipe to the left to continue.")
                    .shimmering()
                    .padding(5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .navigationTitle(Text("User Type"))
        }.padding(20)
    }
}

#Preview {
    OnboardingTwoView()
}
