//
//  ContentView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    // silly options
    @AppStorage("likesMath") var likesMath: Bool = false
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    // user toggles
    @AppStorage("newsIsShown") private var newsIsShown: Bool = true
    @AppStorage("wcfmIsShown") private var wcfmIsShown: Bool = true
    @AppStorage("diningIsShown") private var diningIsShown: Bool = true


    var body: some View {
        if (!hasSeenOnboarding) {
            OnboardingView()
        }
        else {
            TabView {
                Tab("Home", systemImage: "house") {
                    HomeView()
                }
                if newsIsShown {
                    Tab("News", systemImage: "calendar") {
                        NewsView()
                    }
                }
                if diningIsShown {
                    Tab
                    {
                        DiningView()
                    } label: {
                        if likesMath {
                            Label("Dining", systemImage: "pi")
                        } else {
                            Label("Dining", systemImage: "fork.knife")
                        }
                    }
                }
                if wcfmIsShown {
                    Tab("WCFM", systemImage: "radio")
                    {
                        WCFMView()
                    }
                }
                Tab("More", systemImage: "ellipsis.curlybraces") {
                    MoreView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
