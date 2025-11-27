//
//  NewsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct NewsView: View {
    var body: some View {
        NavigationStack {
            List {
                WilliamsRecordView()
            }
            .navigationTitle(Text("News"))
            .navigationSubtitle(Text("The latest happenings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    NewsView()
}
