//
//  WCFMShowViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-03.
//

import SwiftUI
import Combine

@MainActor
class WCFMShowViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var currentShows: WCFMShow?
    @Published var requestURL = URL(string: "https://spinitron.com/api/shows/")

    func loadPlaylists() async {
        isLoading = true
        errorMessage = nil

        do {
                //URLCache.shared.removeAllCachedResponses() // nuke all caches
                // TODO: UNCOMMENT ABOVE BEFORE PROD RELEASE
            let data: WCFMShow = try await getWCFMShow()
            self.currentShows = data
        } catch {
            self.errorMessage = "Failed to load shows."
            self.currentShows = nil
        }

        isLoading = false
    }

}
