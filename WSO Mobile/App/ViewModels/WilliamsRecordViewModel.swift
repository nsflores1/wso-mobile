//
//  WilliamsRecordViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import SwiftUI

@MainActor
@Observable
class WilliamsRecordViewModel {
    var posts: [NewsFeed] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var requestURL: URL = URL(string: "https://www.williamsrecord.com/feed/")!
    private var hasFetched = false

    func loadContent() async {
        isLoading = true
        errorMessage = nil

        do {
            let data: [NewsFeed] = try await parseWilliamsRecord()
            self.posts = data
        } catch {
            self.errorMessage = "Failed to load the Williams Record."
            self.posts = []
                // TODO: this is probably fine to leave it as null, right?
        }

        isLoading = false
    }

    func fetchIfNeeded() async {
        guard !hasFetched else { return }
        hasFetched = true
        await loadContent()
    }

    func forceRefresh() async {
        hasFetched = false
        await fetchIfNeeded()
    }

    func clearCache() async {
        self.posts = []
    }

}
