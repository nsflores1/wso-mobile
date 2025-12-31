//
//  WSOBulletinPerListView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-31.
//

// this view, unlike WSOBulletinListView, represents the view of individual
// full lists, not a master overview of some per-list previews

import SwiftUI
import Logging

struct WSOBulletinPerListView: View {
    let type: String
    @State private var viewModel = WSOBulletinViewModel()
    @State private var searchText = ""

    var body: some View {
        var searchResults: [WSOBulletinItem] {
            if searchText.isEmpty {
                return viewModel.data.filter {
                    $0.type == type
                }
            } else {
                // check the body and title, but first filter by type
                return viewModel.data.filter {
                    $0.type == type &&
                    $0.body.contains(searchText)
                    || $0.title.contains(searchText)
                }
            }
        }
        NavigationStack {
            List {
                ForEach(searchResults) { bulletin in
                    WSOBulletinItemView(
                        post: bulletin,
                        viewModel: WSOUserViewModel(userID: bulletin.userID)
                    )
                }
            }
            .searchable(text: $searchText)
            .task {
                await viewModel.fetchIfNeeded()
            }
            .refreshable {
                await viewModel.forceRefresh()
            }
            .navigationTitle(Text(type.capitalized))
            .modifier(NavSubtitleIfAvailable(subtitle: "Posts on the \(type.capitalized) bulletin"))
        }
    }
}
