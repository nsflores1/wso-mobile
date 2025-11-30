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

    func loadPlaylists() async {
        isLoading = true
        errorMessage = nil

        do {
                //URLCache.shared.removeAllCachedResponses() // nuke all caches
                // TODO: UNCOMMENT ABOVE BEFORE PROD RELEASE
            let data: WCFMPlaylist = try await getWCFMPlaylist()
            self.currentPlaylist = data
        } catch {
            self.errorMessage = "Failed to load playlists."
            self.currentPlaylist = nil
        }

        isLoading = false
    }

}
