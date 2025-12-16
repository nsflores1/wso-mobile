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
    @StateObject private var viewModel = WilliamsRecordViewModel()

    var body: some View {
        Section {
            if viewModel.isLoading {
                    // TODO: make a nicer ProgressView()
                HStack {
                    Text("Loading...")
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            }
            if let error = viewModel.errorMessage {
                    // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                HStack {
                    Text(error)
                        .foregroundStyle(Color.red)
                }
                .listRowSeparator(.hidden)
                .transition(.opacity)
            }
            if !viewModel.isLoading && viewModel.errorMessage == nil {
                // TODO: need to introduce a NavigationLink for posts
                ForEach(viewModel.posts, id: \.title) { post in
                    NavigationLink() {
                        WilliamsRecordArticleView(article: post)
                    } label: {
                        VStack {
                            HStack {
                                    // TODO: make the record article views nicer
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
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
            }
        } header : {
            HStack {
                Text("Williams Record Articles")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Image(systemName: "newspaper")
            }

        } .task { await viewModel.fetchIfNeeded() }
          .refreshable { await viewModel.forceRefresh() }
    }
}

#Preview {
    NewsView()
}
