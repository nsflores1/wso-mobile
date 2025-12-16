//
//  WCFMPlaylistViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-29.
//

import SwiftUI
import Combine

@MainActor
class WCFMPlaylistViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentPlaylist: WCFMPlaylist?
    @Published var requestURL = URL(string: "https://spinitron.com/api/playlists/")
    private var hasFetched = false

    func loadPlaylists() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: WCFMPlaylist = try await getWCFMPlaylist()
            self.currentPlaylist = data
        } catch {
            self.errorMessage = "Failed to load playlists."
            self.currentPlaylist = nil
        }

        isLoading = false
    }
    
    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadPlaylists()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

}
