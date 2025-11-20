//
//  WilliamsRecordArticleView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

import SwiftUI

struct WilliamsRecordArticleView: View {
    let article: CleanRSSPost

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Text(article.title)
                        .bold(true)
                        .padding(20)
                    HStack {
                        Image(systemName: "person")
                        Text("Written by: \(article.author)")
                            .italic(true)
                    }
                }
                Section {
                    Text(article.content)
                        .padding(10)
                }.background(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    NewsView().environmentObject(AppSettings.shared)
}

