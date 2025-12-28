//
//  CacheManager.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-26.
//

// meta-class that handles the common ViewModel task of saving state to and from
// disk, so this makes life much easier

// note that the structs you use with it must be codable. we effectively
// have a data flow that goes as follows throught the app:
// data in -> parse into Codable struct -> ViewModel serves to View & caches ->
// cache client consumes and stores for future loading -> user refreshes,
// we start back from the beginning...

import Foundation

@Observable
class CacheManager {
    static let shared = CacheManager()

    private let baseURL: URL
    // use Task.detached(priority: .utility) to run off the main thread

    private init() {
        let fm = FileManager.default
        baseURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("cache")

        try? fm.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }

    func save<T: Codable>(_ data: T, to path: String) async throws {
        let state = TimestampedData(timestamp: Date(), data: data)
        let fileURL = baseURL.appendingPathComponent(path)

            // make parent dirs if needed
        let parent = fileURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)

        let encoded = try JSONEncoder().encode(state)
        try encoded.write(to: fileURL)
    }

    // default age is one day
    func load<T: Codable>(_ type: T.Type, from path: String,
                          maxAge: TimeInterval = 3600 * 24) async -> T? {
        let fileURL = baseURL.appendingPathComponent(path)

        guard let data = try? Data(contentsOf: fileURL),
              let state = try? JSONDecoder().decode(TimestampedData<T>.self, from: data) else {
            return nil
        }

        if Date().timeIntervalSince(state.timestamp) > maxAge {
            return nil
        }

        return state.data
    }

    func clear(path: String? = nil) async throws {
        if let path = path {
            try FileManager.default.removeItem(at: baseURL.appendingPathComponent(path))
        } else {
            // nuclear option
            try FileManager.default.removeItem(at: baseURL)
            try FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true)
        }
    }
}

// when we're saving data to disk, we use this,
// so that we can bundle the data and a timestamp with it

private struct TimestampedData<T: Codable>: Codable {
    let timestamp: Date
    let data: T
}
