//
//  ContentView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Williams Students Online")
                .font(Font.system(size: 30))
            Divider()
        }
        .padding()
        TabView {
            Tab("News", systemImage: "calendar") {
                NewsView()
            }
            .badge(2)

            // TODO: be a little silly,
            // make this icon change on pi day to
            // pi.square and give users an option to change it

            Tab("Dining", systemImage: "fork.knife") {
                DiningView()
            }
            .badge("?")

            Tab("More", systemImage: "person") {
                ProfileView()
            }
            .badge("!")
        }
    }
}

#Preview {
    ContentView()
}
