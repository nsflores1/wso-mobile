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
