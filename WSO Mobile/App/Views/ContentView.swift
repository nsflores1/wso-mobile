//
//  ContentView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("likesMath") var likesMath: Bool = false

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("News", systemImage: "calendar") {
                NewsView()
            }
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
            Tab("WCFM", systemImage: "radio")
            {
                WCFMView()
            }
            Tab("More", systemImage: "person") {
                ProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
}
