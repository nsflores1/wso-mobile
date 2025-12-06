//
//  WCFMShowsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-25.
//

import SwiftUI
import Combine

struct WCFMShowsView: View {
    @StateObject private var viewModel = WCFMShowViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(
                    viewModel.currentShows?.items ?? [],
                    id: \.id
                ) { show in
                    VStack {
                        HStack {
                            VStack {
                                Text(show.title)
                                    .font(.title2)
                                    .italic()
                            }
                            Spacer()
                            AsyncImage(url: URL(string: show.image)!)
                                .frame(width: 150, height: 150)
                                .cornerRadius(12)
                        }
                        Text("\(show.start.shortDisplay) - \(show.end.shortDisplay)")
                            .font(.subheadline)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .opacity
                ))
            }
            .navigationTitle("Recent Shows")
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
        }
        .task { await viewModel.loadPlaylists() }
        .refreshable {
            URLCache.shared
                .removeCachedResponse(
                    for: URLRequest(url: viewModel.requestURL!)
                )
        }
    }
}

#Preview {
    WCFMShowsView()
}
