//
//  WilliamsRecordView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-18.
//

import FeedKit
import SwiftUI
import Foundation
import SwiftSoup

struct WilliamsRecordView: View {
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
                ForEach(viewModel.posts, id: \.title) { post in
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
                                    .italic()
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }.transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
        .task { await viewModel.fetchIfNeeded() }
        .refreshable {
            await viewModel.forceRefresh()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

#Preview {
    NewsView()
}
