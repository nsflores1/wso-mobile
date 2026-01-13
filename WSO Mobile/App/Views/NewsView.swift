//
//  NewsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import Logging

struct NewsView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = WilliamsRecordViewModel()

    var body: some View {
        NavigationStack {
            // TODO: add more news sources here
            WilliamsRecordView()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: NewsKeyView()) {
                            Image(systemName: "questionmark")
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
            }
            .navigationTitle(Text("News"))
            .modifier(NavSubtitleIfAvailable(subtitle: "The latest happenings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NewsView()
}
