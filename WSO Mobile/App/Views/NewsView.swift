//
//  NewsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = WilliamsRecordViewModel()

    var body: some View {
        NavigationStack {
            List {
                WilliamsRecordView()
            }
            .navigationTitle(Text("News"))
            .modifier(NavSubtitleIfAvailable(subtitle: "The latest happenings"))
            .navigationBarTitleDisplayMode(.large)
        }.refreshable {
            URLCache.shared
                .removeCachedResponse(
                    for: URLRequest(url: viewModel.requestURL)
                )
            await viewModel.forceRefresh()
        }
    }
}

#Preview {
    NewsView()
}
