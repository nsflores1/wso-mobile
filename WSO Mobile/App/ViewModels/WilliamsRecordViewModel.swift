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
    var error: WebRequestError?
    private var hasFetched = false

    func loadContent() async {
        isLoading = true
        error = nil

        do {
            let data: [NewsFeed] = try await parseWilliamsRecord()
            self.posts = data
        }  catch let err as WebRequestError {
            self.error = err
            self.posts = []
        } catch {
            self.error = WebRequestError.internalFailure
            self.posts = []
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
