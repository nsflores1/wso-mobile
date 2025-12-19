//
//  NewsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct NewsView: View {
    @State private var viewModel = WilliamsRecordViewModel()

    var body: some View {
        NavigationStack {
            WilliamsRecordView()
            .navigationTitle(Text("News"))
            .modifier(NavSubtitleIfAvailable(subtitle: "The latest happenings"))
            .navigationBarTitleDisplayMode(.large)
        }.refreshable {
            await viewModel.forceRefresh()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

#Preview {
    NewsView()
}
