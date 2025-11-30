//
//  WCFMPlaylistView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-25.
//

import SwiftUI
import Combine

struct WCFMPlaylistView: View {
    @StateObject private var viewModel = WCFMPlaylistViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.currentPlaylist?.items ?? [], id: \.id) { playlist in
                    VStack {
                        HStack {
                            VStack {
                                Text(playlist.title)
                                    .font(.title2)
                                    .italic()
                            }
                            Spacer()
                            AsyncImage(url: URL(string: playlist.image)!)
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                        }
                        Text("\(playlist.start.shortDisplay) - \(playlist.end.shortDisplay)")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Recent Playlists")
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
    WCFMPlaylistView()
}
