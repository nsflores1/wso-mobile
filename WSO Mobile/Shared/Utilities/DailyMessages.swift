//
//  DailyMessages.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import Foundation
import SwiftSoup

struct DailyMessageCategory: Codable {
    let categories: [String: [DailyMessagePost]]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode([String: [DailyMessagePost]].self)

            // strip html from category names (the keys)
        var cleaned: [String: [DailyMessagePost]] = [:]
        for (rawKey, posts) in raw {
            let cleanKey = Self.stripHTML(rawKey).cleanWhitespace()
            cleaned[cleanKey] = posts
        }

        self.categories = cleaned
    }

    private static func stripHTML(_ html: String) -> String {
        (try? SwiftSoup.parse(html).text()) ?? html
    }
}


struct DailyMessagePost: Codable {
    private let rawTitle: String
    private let rawAuthor: String
    private let rawAuthorEmail: String
    private let rawStartTime: String
    private let rawContent: String
    private let rawLdapDepartment: String

    // these weirdly come with whitespace, so we have to clean everything
    var title: String { stripHTML(rawTitle).cleanWhitespace() }
    var author: String { stripHTML(rawAuthor).cleanWhitespace() }
    var authorEmail: String { stripHTML(rawAuthorEmail).cleanWhitespace() }
    var startTime: String { stripHTML(rawStartTime).cleanWhitespace() }
    var content: String { stripHTML(rawContent).cleanWhitespace() }
    var ldapDepartment: String { stripHTML(rawLdapDepartment).cleanWhitespace() }

    private func stripHTML(_ html: String) -> String {
        (try? SwiftSoup.parse(html).text()) ?? html
    }

    // needed to match good swift style
    enum CodingKeys: String, CodingKey {
        case rawTitle = "title"
        case rawAuthor = "author"
        case rawAuthorEmail = "author_email"
        case rawStartTime = "start_ts"
        case rawContent = "content"
        case rawLdapDepartment = "ldap_department"
    }
}

struct DailyMessagesParseError : Error {}

func parseDailyMessages() async throws -> [String: [DailyMessagePost]] {
    let url = URL(string: "https://events.williams.edu/wp-json/wms/events/v1/list/dm")!
    let (data, _) = try await URLSession.shared.data(from: url)

        // debug feature, hidden. unhide to see raw URL read data
        // let str = (String(data: data, encoding: .utf8) ?? "No data")

    do {
        let decodedResponse = try JSONDecoder().decode(DailyMessageCategory.self, from: data)
        return decodedResponse.categories
    } catch {
        // TODO: handle this in the GUI.
        // maybe we need some way to handle past daily messages,
        // and be able to load those from remote.
        // but for now this works.
        throw DailyMessagesParseError()
    }
}

func doDailyMessages() async {
    do {
        let data = try await parseDailyMessages()
        for (categoryName, eventThing) in data {
            print("### category: \(categoryName) ###")
            for event in eventThing {
                let soupTitle = try SwiftSoup.parse(event.title).text()
                print("---- \(soupTitle)")
                print("run by \(event.author) (\(event.authorEmail))")
                print("department: \(event.ldapDepartment)")
                print("on date: \(event.startTime)")
                let soupContent = try SwiftSoup.parse(event.content).text()
                print("content: \(soupContent)")
            }
        }
    }
    catch {
        print("no daily messages today")
    }
}
