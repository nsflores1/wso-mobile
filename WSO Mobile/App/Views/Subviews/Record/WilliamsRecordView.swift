//
//  WilliamsRecordView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-18.
//

import SwiftUI
import Foundation
import Logging

struct WilliamsRecordView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = WilliamsRecordViewModel()
    @AppStorage("likesSerifFont") private var likesSerifFont: Bool = false

    var body: some View {
        List {
            if viewModel.isLoading {
                HStack {
                    ProgressView()
                        .alignmentGuide(VerticalAlignment.center) { _ in 0.5 }
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            }
            if let err = viewModel.error {
                HStack {
                    Text(err.localizedDescription)
                        .foregroundStyle(Color.red)
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
                .refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
            if !viewModel.isLoading && viewModel.error == nil {
                ForEach(viewModel.posts.sorted(), id: \.title) { post in
                    NavigationLink() {
                        WilliamsRecordArticleView(article: post)
                    } label: {
                        VStack {
                            HStack {
                                Text(post.title)
                                    .multilineTextAlignment(.leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Image(systemName: "person")
                                Text(post.author)
                                    .multilineTextAlignment(.leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.secondary)
                            HStack {
                                Image(systemName: "clock")
                                Text(post.pubDate.shorterDisplay)
                                    .multilineTextAlignment(.leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(Color.secondary)
                        }
                    }.transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
        .task {
            logger.trace("Fetching news data...")
            await viewModel.fetchIfNeeded()
            logger.trace("Fetch complete")
        }
        .refreshable {
            logger.trace("News data is being forcibly refreshed...")
            await viewModel.forceRefresh()
            logger.trace("News data forcibly refreshed")
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        .modifier(
            NavSubtitleIfAvailable(
                subtitle: "Last updated: \(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")"
            )
        )
    }
}

#Preview {
    NewsView()
}
