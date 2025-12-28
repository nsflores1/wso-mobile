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

// Task is used to create a new calling context that isn't on the main
// thread, so that we get a non-locking I/O interface. otherwise it runs
// on the main thread and failing I/O can deadlock the whole app!

import Foundation

@Observable
class CacheManager {
    static let shared = CacheManager()
    private let baseURL: URL

    private init() {
        let fm = FileManager.default
        baseURL = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("cache")

        try? fm.createDirectory(at: baseURL, withIntermediateDirectories: true)
    }

    func save<T: Codable>(_ data: T, to path: String) async throws {
        return try await Task {
            let encoder = JSONEncoder()
            let state = TimestampedData(timestamp: Date(), data: data)
            let fileURL = self.baseURL.appendingPathComponent(path)

            // make parent dirs if needed
            let parent = fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)

            let encoded = try encoder.encode(state)
            try encoded.write(to: fileURL)
        }.value
    }

    // default age is one day
    func load<T: Codable>(_ type: T.Type, from path: String,
                          maxAge: TimeInterval = 3600 * 24) async -> T? {
        return await Task {
            let decoder = JSONDecoder()
            let fileURL = self.baseURL.appendingPathComponent(path)

            guard let data = try? Data(contentsOf: fileURL),
                  let state = try? decoder.decode(TimestampedData<T>.self, from: data) else {
                return nil
            }

            if Date().timeIntervalSince(state.timestamp) > maxAge {
                return nil
            }

            return state.data
        }.value
    }

    func clear(path: String? = nil) async {
        Task {
            if let path = path {
                try FileManager.default
                    .removeItem(at: self.baseURL.appendingPathComponent(path))
            } else {
                    // nuclear option
                try FileManager.default.removeItem(at: self.baseURL)
                try FileManager.default.createDirectory(
                        at: self.baseURL,
                        withIntermediateDirectories: true
                    )
            }
        }
    }
}

// when we're saving data to disk, we use this,
// so that we can bundle the data and a timestamp with it

struct TimestampedData<T: Codable>: Codable {
    let timestamp: Date
    let data: T
}
