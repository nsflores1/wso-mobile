//
//  WilliamsRecordArticleView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

import SwiftUI
import Kingfisher

struct WilliamsRecordArticleView: View {
    let article: NewsFeed
    // to whomever maintains this after me:
    // I am so sorry.
    @AppStorage("likesSerifFont") private var likesSerifFont: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text(article.title)
                        .font(likesSerifFont ? .garamond(.body) : .body)
                        .bold(true)
                        .padding(20)
                    HStack {
                        Image(systemName: "person")
                        Text("Written by: \(article.author)")
                            .italic(true)
                            .font(likesSerifFont ? .garamond(.body) : .body)
                    }
                }
                Divider()
                Section {
                    ForEach(article.content.indices, id: \.self) { idx in
                        switch article.content[idx] {
                            case .text(let content):
                                Text(content)
                                    .multilineTextAlignment(.leading)
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .font(likesSerifFont ? .garamond(.body) : .body)
                            case .image(let url, let caption):
                                VStack {
                                    KFImage(URL(string: url))
                                        .placeholder { ProgressView() }
                                        .fade(duration: 0.25)
                                        .resizable()
                                        .cornerRadius(10)
                                        .scaledToFit()
                                    // this parameter prevents massive vertical images
                                        .frame(maxWidth: 360, maxHeight: 300)
                                    Text(caption)
                                        .font(likesSerifFont ? .garamond(.caption) : .caption)
                                        .italic()
                                        .padding(10)
                                }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        ShareLink(item: article.link) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewsView()
}

