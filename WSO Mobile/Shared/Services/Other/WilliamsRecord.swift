//
//  WilliamsRecord.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import SwiftSoup
import Foundation
import FeedKit

struct NewsFeed: Codable {
    let title: String
    let link: URL
    let pubDate: Date
    let author: String
    let description: String
    let content: [ArticleElement]
    let updateTime: Date?
    let category: [RSSFeedCategory]?
}

// it makes most sense to sort them by date, from oldest to newest
extension NewsFeed: Comparable {
    static func < (lhs: NewsFeed, rhs: NewsFeed) -> Bool {
        return lhs.pubDate > rhs.pubDate
    }
    static func == (lhs: NewsFeed, rhs: NewsFeed) -> Bool {
        return lhs.pubDate == rhs.pubDate
    }
}

enum ArticleElement: Codable {
    case text(String)
    case image(url: String, caption: String)
}

// this function reduces all the text blocks. it's nice for visual stuff
// because apple already handled rendering long text blocks for you.
// a bunch of small ones typically looks bad and un-article-like.
func mergeTextBlocks(_ elements: [ArticleElement]) -> [ArticleElement] {
    return elements.reduce(into: [ArticleElement]()) { result, element in
        switch (result.last, element) {
            case (.text(let existing), .text(let new)):
                result[result.count - 1] = .text(existing + "\n\n" + new)
            default:
                result.append(element)
        }
    }
}

func parseArticleContent(_ content: String) async throws -> [ArticleElement] {
    let doc = try SwiftSoup.parse(content)
    let paragraphs = try doc.select("p")

    var elements: [ArticleElement] = []

    // grab figure if it exists
    if let figure = try? doc.select("figure").first(),
       let img = try? figure.select("img").first(),
       let src = try? img.attr("src") {
        let caption = (try? figure.select("figcaption").first()?.text()) ?? ""
        elements.append(.image(url: src, caption: caption))
    }

    elements.append(contentsOf: paragraphs.array().compactMap { p in
        if let img = try? p.select("img").first(),
           let src = try? img.attr("src") {
            let caption = (try? img.attr("alt")) ?? (try? p.text()) ?? ""
            return .image(url: src, caption: caption)
        } else if let text = try? p.text(), !text.isEmpty {
            return .text(text)
        }
        return nil
    })
    return mergeTextBlocks(elements)
}

func parseWilliamsRecord() async throws -> [NewsFeed] {
    let feed = try await RSSFeed(urlString: "https://wso.williams.edu/mobile/williams_record.rss")
    // this is probably safe but needs more sanity checks
    // also I could do this with a .map but it's simply too complicated to be worth it
    // this is naturally an iterative task. and its pretty fast too since n is small
    var news: [NewsFeed] = []
    for post in feed.channel?.items ?? [] {
        news
            .append(
                NewsFeed(
                    title: post.title ?? "",
                    link: URL(string: post.link ?? "https://williamsrecord.com")!,
                    pubDate: post.pubDate!, // TODO: implement a thing which gives us 8am of last wednesday
                    author: post.dublinCore?.creator ?? "(unknown author)",
                    description: post.description ?? "(no description)",
                    content: try await parseArticleContent(post.content?.encoded ?? ""),
                    updateTime: post.pubDate,
                    category: post.categories
                )
            )
    }
    return news
}

func doWilliamsRecord() async {
    do {
        let data = try await parseWilliamsRecord()
        for post in data {
            print("####")
            print(post.title)
            print(post.author)
            print(post.link)
            print(post.pubDate)
            for node in post.content {
                switch node {
                    case .text(let content):
                        print("Text: ", content)
                    case .image(url: let url, caption: let caption):
                        print("Image (url):", url, "Image (caption):", caption)
                }
            }
        }
    } catch {
        print("No Williams Record today")
    }

}
