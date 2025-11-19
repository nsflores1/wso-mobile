//
//  WilliamsRecordViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import FeedKit
import SwiftUI
import Combine
import SwiftSoup
import XMLKit

@MainActor
class WilliamsRecordViewModel: ObservableObject {
    @Published var posts: [CleanRSSPost] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadContent() async {
        isLoading = true
        errorMessage = nil

        do {
            let items = try await parseWilliamsRecord()
            posts = items.compactMap { item in
                guard let title = item.title,
                      let rawContent = item.content?.encoded
                else { return CleanRSSPost(
                    id: "(Unknown)",
                    title: "(Unknown)",
                    author: "(Unknown)",
                    content: "(Unknown)"
                ) }

                let cleanContent = (
                    try? SwiftSoup.parse(rawContent).text()
                ) ?? rawContent

                return CleanRSSPost(
                    id: item.guid?.text ?? "(Unknown)",
                    title: title,
                    author: item.dublinCore?.creator ?? "(Unknown)",
                    content: cleanContent
                )
            }
        } catch {
            self.errorMessage = "Failed to load the Williams Record."
            self.posts = []
            // TODO: this is probably fine to leave it as null, right?
        }

        isLoading = false
    }

}

struct CleanRSSPost: Identifiable {
    let id: String
    let title: String
    let author: String
    let content: String
}

