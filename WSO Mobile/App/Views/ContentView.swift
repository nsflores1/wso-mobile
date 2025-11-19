//
//  ContentView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var state = ContentViewModel()
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("News", systemImage: "calendar") {
                NewsView()
            }
            Tab("Dining", systemImage: state.diningIcon)
            {
                DiningView()
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
    ContentView().environmentObject(AppSettings.shared)
}
