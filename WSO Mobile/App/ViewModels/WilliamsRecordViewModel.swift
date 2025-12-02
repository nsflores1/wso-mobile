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

struct CleanRSSPost: Identifiable {
    let id: String
    let title: String
    let author: String
    let content: [String]
}

@MainActor
class WilliamsRecordViewModel: ObservableObject {
    @Published var posts: [CleanRSSPost] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var requestURL: URL = URL(string: "https://www.williamsrecord.com/feed/")!

    func loadContent() async {
        isLoading = true
        errorMessage = nil

        do {
                //URLCache.shared.removeAllCachedResponses() // nuke all caches
                // TODO: UNCOMMENT ABOVE BEFORE PROD RELEASE
            let items = try await parseWilliamsRecord()
            var returnValue: [CleanRSSPost] = []
            for item in items {
                let title = item.title
                let rawContent = item.content?.encoded ?? ""

                let soupText = try SwiftSoup.parse(rawContent)
                let paragraphs = try soupText.select("p")

                var soupContent = [String]()

                for p in paragraphs {
                    let p = try p.text()
                    soupContent.append(p)
                }
                
                returnValue.append(
                    CleanRSSPost(
                        id: item.guid?.text ?? "(Unknown)",
                        title: title ?? "(Unknown)",
                        author: item.dublinCore?.creator ?? "(Unknown)",
                        content: soupContent
                    )
                )
            }
            posts = returnValue
        } catch {
            self.errorMessage = "Failed to load the Williams Record."
            self.posts = []
                // TODO: this is probably fine to leave it as null, right?
        }

        isLoading = false
    }

}
