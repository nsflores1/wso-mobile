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
                Text("Loading...")
            } else if let error = viewModel.errorMessage {
                    // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                Text(error).foregroundStyle(Color.red)
            } else {
                // TODO: need to introduce a NavigationLink for posts
                ForEach(viewModel.posts, id: \.id) { post in
                    NavigationLink() {
                        WilliamsRecordArticleView(article: post)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                    }
                }
            }
        } header : {
            HStack {
                Text("Williams Record Articles")
                    .fontWeight(.semibold)
                    .font(.title3)
                Spacer()
                Image(systemName: "newspaper")
            }

        } .task { await viewModel.loadContent() }
    }
}

#Preview {
    NewsView().environmentObject(AppSettings.shared)
}
