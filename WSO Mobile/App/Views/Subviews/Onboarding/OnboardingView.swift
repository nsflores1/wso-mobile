//
//  OnboardingView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

// Users will see this EXACTLY ONCE, but can
// reset their app to see it multiple times if they want.

import SwiftUI
import Shimmer

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

struct OnboardingOneView: View {
    var body: some View {
        NavigationStack {
            VStack {
                let mainText = """
                You're using:
                WSO Mobile Rewritten, v1.4.2 (Fantastic FacTrak)!
                
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
                    .hapticTap(.rigid)
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

struct OnboardingThreeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
                    WSO Mobile is constantly under development and is not complete yet.
                    
                    Features which are still not implemented in this version compared to our web client include:
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

struct OnboardingFiveView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    let mainText = """
                    If you find any bugs with the app, please let us know by contacting us. You can do this from the forms on the Links tab of the app.
                    
                    WSO Mobile, like the rest of WSO, is always improving, so please be sure to update your app, log in and out, and clear caches before submitting feedback; it's possible that we have already removed a bug in the latest update!
                    
                    Thanks again for using the app!
                    
                    If you want to see any of this text again, change the setting in the app to reset your onboarding progress.
                    """
                    Text(mainText)
                }.padding(20)
                Spacer()
                VStack {
                    Text("Ready to go!")
                        .shimmering()
                    Button("Get started") {
                        hasSeenOnboarding = true
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    }
                    .buttonStyle(.borderedProminent)
                }
                Spacer()
            }
            .navigationTitle(Text("Complete!"))
        }.padding(20)
    }
}

#Preview {
    OnboardingView()
}
