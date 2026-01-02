//
//  DecodingError.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-01.
//

// so this is some very special code for catching a decoding error...
// and print it out to the syslog.

import Foundation
import Logging

func logDecodingError(_ error: DecodingError, logger: Logger) {
    switch error {

        case .dataCorrupted(let context):
            logger.error("""
        dataCorrupted:
        path: \(codingPath(context.codingPath))
        debug: \(context.debugDescription)
        underlying: \(String(reflecting: context.underlyingError))
        """)

        case .keyNotFound(let key, let context):
            logger.error("""
        keyNotFound:
        key: \(key.stringValue)
        path: \(codingPath(context.codingPath))
        debug: \(context.debugDescription)
        """)

        case .typeMismatch(let type, let context):
            logger.error("""
        typeMismatch:
        expected: \(type)
        path: \(codingPath(context.codingPath))
        debug: \(context.debugDescription)
        """)

        case .valueNotFound(let type, let context):
            logger.error("""
        valueNotFound:
        expected: \(type)
        path: \(codingPath(context.codingPath))
        debug: \(context.debugDescription)
        """)
        @unknown default:
            logger.error("\(error.localizedDescription)")
    }
}

func codingPath(_ path: [CodingKey]) -> String {
    path.map { $0.stringValue }.joined(separator: ".")
}
