//
//  WCFMPlaylistView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-25.
//

import SwiftUI
import Kingfisher

struct WCFMPlaylistView: View {
    @State private var viewModel = WCFMPlaylistViewModel()

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
                            KFImage(URL(string: playlist.image)!)
                                .placeholder { ProgressView() }
                                .fade(duration: 0.25)
                                .frame(width: 150, height: 150)
                                .cornerRadius(12)
                        }
                        Text("\(playlist.start.shortDisplay) - \(playlist.end.shortDisplay)")
                            .font(.subheadline)
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .opacity
                ))
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.isLoading)
            .navigationTitle("Recent Playlists")
        }
        .task { await viewModel.fetchIfNeeded() }
        .refreshable {
            await viewModel.forceRefresh()
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

#Preview {
    WCFMPlaylistView()
}
