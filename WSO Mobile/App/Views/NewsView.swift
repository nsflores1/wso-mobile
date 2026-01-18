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
            .navigationBarTitleDisplayMode(.large)
            // the modifier is set within WilliamsRecordView!
            // a bit counterintuitive, but Views can't pass data up. questionable architecture?
            // futureproofing for when we add new content to the system? you decide.
        }
    }
}

#Preview {
    NewsView()
}
