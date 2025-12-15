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
    let content: [NewsNode]
}

enum NewsNodeType: Codable {
    case image
    case text
    // TODO: add more cases if needed
}

struct NewsNode: Codable {
    let type: NewsNodeType
    let content: String?
    let imageURL: String?
    let imageCaption: String?
}

struct WilliamsRecordParseError: Error {}

//func parseWilliamsRecord() async throws -> [NewsFeed] {
//    let feed = try await RSSFeed(urlString: "https://wso.williams.edu/williams_record.rss")
//    // this is probably safe but needs more sanity checks
//    // also I could do this with a .map but it's simply too complicated to be worth it
//    // this is naturally an iterative task. and its pretty fast too since n is small
//    var news: [NewsFeed] = []
//    for post in feed.channel?.items ?? [] {
//        news
//            .append(
//                NewsFeed(
//                    title: post.title ?? "",
//                    link: URL(string: post.link ?? "https://williamsrecord.com")!,
//                    pubDate: post.pubDate!, // TODO: implement a thing which gives us 8am of last wednesday
//                    author: post.author ?? "(unknown author)",
//                    description: post.description ?? "(no description)",
//                    content: {
//                        let soupText = try SwiftSoup.parse(post.content!.encoded!)
//                        let paragraphs = try soupText.select("p")
//                    }
//                )
//            )
//    }
//}

// this doesn't need a rewrite because FeedKit implements parsing for us
func parseWilliamsRecord() async throws -> [RSSFeedItem] {
    do {
        let feed = try await RSSFeed(urlString: "https://wso.williams.edu/williams_record.rss")
        return feed.channel?.items ?? []

        // TODO: this is way, way too simple. we need to do the following things:
        // - parse an article for its CDATA and store the attachement with Kingfisher,
        // then make it nice and blurred so users can click on it
        // - collect every <p> tag and store it

    } catch {
        // this will throw in even the most minor parse error,
        // but that's good. we want to be careful
        throw WilliamsRecordParseError()
    }
}

func doWilliamsRecord() async {
    do {
        let data = try await parseWilliamsRecord()
        for (post) in data {
            print(post.title!)
            print(post.link!)
            print(post.pubDate ?? "")
            print(post.dublinCore?.creator ?? "Unknown")
            print(post.description ?? "No description")
            let soupText = try SwiftSoup.parse(post.content!.encoded!)
            let paragraphs = try soupText.select("p")
            let imageURL = try soupText.select("img")
            let captions = try soupText.select("figcaption")

            print()
//            print(post.content!)
            print()

            var soupCaptionContent: [String] = []
            var soupImageContent: [String] = []

            // loop over elements to see them, like for p in paragraph,
            // add it to our soupcontent...

            for caption in captions {
                let caption = try caption.text()
                soupCaptionContent.append(caption)
            }

            for image in imageURL {
                let image = try image.attr("src")
                soupImageContent.append(image)
            }
            for p in paragraphs {
                print("Paragraph:", p)
            }

            for i in soupImageContent {
                print("Image:", i)
            }

            for i in soupCaptionContent {
               print("Caption:", i)
            }

            print()

        }
    } catch {
        print("No Williams Record today")
    }

}
