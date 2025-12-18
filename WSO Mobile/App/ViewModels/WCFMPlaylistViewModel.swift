//
//  WCFMPlaylistViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-29.
//

import SwiftUI

@MainActor
@Observable
class WCFMPlaylistViewModel {
    var isLoading: Bool = false
    var errorMessage: String?
    var currentPlaylist: WCFMPlaylist?
    var requestURL = URL(string: "https://spinitron.com/api/playlists/")
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

    func clearCache() async {
        self.currentPlaylist = nil
    }

}
