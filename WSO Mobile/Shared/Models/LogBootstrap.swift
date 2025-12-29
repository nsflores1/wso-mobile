//
//  LogBootstrap.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

// this isn't a model in the normal sense, but rather something that helps
// set up the logging engine, which takes place in our app initialization

// emojis are added to the file because they're user-facing
// (duh)

import Logging
import Foundation

// custom file logger backend
struct FileLogHandler: LogHandler {
    private let fileHandle: FileHandle
    private let label: String

    var metadata = Logger.Metadata()
    var logLevel = Logger.Level.debug

    init(label: String, fileURL: URL) {
        self.label = label

        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        }
        self.fileHandle = try! FileHandle(forWritingTo: fileURL)
        fileHandle.seekToEndOfFile()
    }

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    func log(level: Logger.Level, message: Logger.Message,
             metadata: Logger.Metadata?, source: String,
             file: String, function: String, line: UInt) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let emoji = level.emoji
        let prettyMetadata = (self.metadata.merging(metadata ?? [:]) { $1 })
            .map { "\($0)=\($1)" }
            .joined(separator: " ")

        let logLine = "\(timestamp) \(emoji) [\(level)] [\(label)] \(message) \(prettyMetadata)\n"

        if let data = logLine.data(using: .utf8) {
            fileHandle.write(data)
        }
    }
}

extension Logger.Level {
    var emoji: String {
        switch self {
            case .trace: return "🔍"
            case .debug: return "🐛"
            case .info: return "ℹ️"
            case .notice: return "📝"
            case .warning: return "⚠️"
            case .error: return "❌"
            case .critical: return "🔥"
        }
    }
}

// multiplexer to send to both
struct MultiplexLogHandler: LogHandler {
    private var handlers: [LogHandler]

    var metadata = Logger.Metadata() {
        didSet {
            handlers = handlers.map { handler in
                var h = handler
                h.metadata = metadata
                return h
            }
        }
    }

    var logLevel = Logger.Level.debug {
        didSet {
            handlers = handlers.map { handler in
                var h = handler
                h.logLevel = logLevel
                return h
            }
        }
    }

    init(handlers: [LogHandler]) {
        self.handlers = handlers
    }

    subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set {
            metadata[key] = newValue
            handlers = handlers.map { handler in
                var h = handler
                h[metadataKey: key] = newValue
                return h
            }
        }
    }

    func log(level: Logger.Level, message: Logger.Message,
             metadata: Logger.Metadata?, source: String,
             file: String, function: String, line: UInt) {
        handlers.forEach { handler in
            let h = handler
            h.log(level: level, message: message, metadata: metadata,
                  source: source, file: file, function: function, line: line)
        }
    }
}
