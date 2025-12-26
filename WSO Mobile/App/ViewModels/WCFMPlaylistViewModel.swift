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
    var error: WebRequestError?
    var currentPlaylist: WCFMPlaylist?
    private var hasFetched = false

    func loadPlaylists() async {
        isLoading = true
        error = nil

        do {
            let data: WCFMPlaylist = try await getWCFMPlaylist()
            self.currentPlaylist = data
        } catch let err as WebRequestError {
            self.error = err
            self.currentPlaylist = nil
        } catch {
            self.error = WebRequestError.internalFailure
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
