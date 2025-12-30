//
//  DailyMessagesItemView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

import SwiftUI
import Logging

struct DailyMessagesItemView: View {
    let post: DailyMessagePost

    var body: some View {
        DisclosureGroup {
            VStack {
                Text(post.content)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.leading)
            }
        } label: {
            VStack() {
                HStack {
                    Text(post.title)
                    Spacer()
                }
                HStack() {
                    Image(systemName: "person")
                    Text(post.author)
                    Spacer()
                }.foregroundStyle(Color.secondary)
            }.swipeActions(edge: .trailing) {
                ShareLink(item: post.url) {
                    Label("Share", systemImage: "square.and.arrow.up")
                }
                .tint(.blue)
                if post.itemURL != nil {
                    ShareLink(item: post.itemURL!) {
                        Label("Open", systemImage: "network")
                    }
                    .tint(.green)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                // the .frame() trick is Dark Arts
        }
    }
}
