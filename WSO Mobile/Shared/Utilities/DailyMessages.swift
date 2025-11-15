//
//  DailyMessages.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-14.
//

import Foundation
import SwiftSoup

    // The type implementing the text of a daily message.
struct DailyMessageCategory: Codable {
    let categories: [String: [DailyMessagePost]]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        categories = try container.decode([String: [DailyMessagePost]].self)
    }
}
struct DailyMessagePost: Codable {
    let title: String
    let author: String
    let authorEmail: String
    let startTime: String
    let content: String
    let ldapDepartment: String

    // needed to match good swift stylee
    enum CodingKeys: String, CodingKey {
        case title
        case author
        case authorEmail = "author_email"
        case startTime = "start_ts"
        case content
        case ldapDepartment = "ldap_department"
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
