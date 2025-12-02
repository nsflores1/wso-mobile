//
//  WilliamsRecord.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import SwiftSoup
import Foundation
import FeedKit

struct WilliamsRecordParseError : Error {}

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
            print(post.dublinCore?.creator ?? "Unknown")
            let soupText = try SwiftSoup.parse(post.content!.encoded!)
            let paragraphs = try soupText.select("p")

            var soupContent: [String] = []

            for p in paragraphs {
                let p = try p.text()
                soupContent.append(p)
            }

            for i in soupContent {
                print(i)
            }

        }
    } catch {
        print("No Williams Record today")
    }

}
