//
//  SpinitronMetadata.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-21.
//

// this service abstracts the process of making calls to spinitron and getting
// metadata for WCFM. in particular, it makes interfaces to do like
// 90% of what you actually want to do.
// TODO: BEFORE RELEASING THIS: have WSO scrape this file,
// NOT you! it's bad for the API key to be leaked openly, it's much
// safer for backend to handle this.

// TODO: DO NOT SHIP THE APP WITH THE API KEY!

import Foundation
import Combine
import HTTPTypes
import HTTPTypesFoundation

struct WCFMPlaylist: Codable {
    var metaLinks: [String: [String: URL]]
    var metaMeta : [String: Int]
    var items: [WCFMPlaylistItem]

    enum CodingKeys: String, CodingKey {
        case metaLinks = "_links"
        case metaMeta = "_meta"
        case items
    }
}

struct WCFMPlaylistItem: Codable {
    var id: Int
    var start: Date
    var end: Date
    var title: String
    var image: String
    var spinsCount: String
    var metaLinks: [String: [String: URL]]

    enum CodingKeys: String, CodingKey {
        case id
        case start
        case end
        case title
        case image
        case spinsCount
        case metaLinks = "_links"
    }
}

struct WCFMSpin: Codable {
    var metaLinks: [String: [String: URL]]
    //TODO: may want to implement metaMeta at some point
    var items: [WCFMSpinItem]

    enum CodingKeys: String, CodingKey {
        case metaLinks = "_links"
        case items
    }
}

struct WCFMSpinItem: Codable {
    var id: Int
    var start: Date
    var end: Date
    var artist: String?
    var composer: String?
    var song: String
    var label: String?
    var image: URL?
    var release: String?
    var released: Int?
    // TODO: maybe add playlist_id here
}

struct WCFMPlaylistParseError : Error {}
struct WCFMSpinParseError : Error {}

func getWCFMPlaylist() async throws -> WCFMPlaylist {
    let request = HTTPRequest(method: .get, url: URL(string: "https://wso.williams.edu/playlists.json")!)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let decodedResponse = try decoder.decode(WCFMPlaylist.self, from: data)
    return decodedResponse
}

func getWCFMSpin() async throws -> WCFMSpin {
    let request = HTTPRequest(method: .get, url: URL(string: "https://wso.williams.edu/spins.json")!)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    let decodedResponse = try decoder.decode(WCFMSpin.self, from: data)
    return decodedResponse
}

// strategy to get the latest playlist:
// find the date and time. then, go over the array, and return the one
// that we're currently at because we should fall within its range.

// strategy to get the current song:
// get the playlist, then get the spins of the latest playlist.
// the latest song in that spin is the current song.

// you do need to make these performant,
// since you'll be running them once every few seconds.

func doWCFMPlaylist() async throws {
        let playlist = try await getWCFMPlaylist()
        for thing in playlist.items {
            print("show \(thing.title) runs from \(thing.start) to \(thing.end)")
            for (key, value) in thing.metaLinks {
                print("show \(thing.title): \(key): \(value)")
            }
        }
}

func doWCFMSpin() async throws {
    let spin = try await getWCFMSpin()
    for thing in spin.items {
        print("spin \(thing.song) by \(thing.artist, default: "Anonymous") released \(thing.released, default: "(no release date)")")
    }
}
