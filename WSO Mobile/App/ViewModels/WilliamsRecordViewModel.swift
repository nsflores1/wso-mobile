//
//  WilliamsRecordViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import SwiftUI
import Combine

@MainActor
class WilliamsRecordViewModel: ObservableObject {
    @Published var posts: [NewsFeed] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var requestURL: URL = URL(string: "https://www.williamsrecord.com/feed/")!

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

}
