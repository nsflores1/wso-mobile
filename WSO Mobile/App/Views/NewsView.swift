//
//  NewsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, News!")
            }
            VStack(alignment: .leading) {
                Text("Someday, a daily message will go here!")
                    .padding()
            }
        }
    }
}
