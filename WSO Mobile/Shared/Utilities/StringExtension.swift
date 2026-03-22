//
//  StringExtension.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-17.
//

import Foundation

// whitespace murdering tool
extension String {
    func cleanWhitespace() -> String {
            // strip ALL unicode whitespace, not just ascii spaces
        self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// some debug messages are absurdly long,
// so here's a short method to truncate them to an appropriate size.
extension String {
    func truncated(to maxLength: Int, suffix: String = "…") -> String {
        guard count > maxLength else { return self }
        let end = index(startIndex, offsetBy: maxLength)
        return self[..<end] + suffix
    }
}
