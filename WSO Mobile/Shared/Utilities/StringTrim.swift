//
//  StringTrim.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-31.
//

// some debug messages are absurdly long,
// so here's a short method to truncate them to an appropriate size.
extension String {
    func truncated(to maxLength: Int, suffix: String = "…") -> String {
        guard count > maxLength else { return self }
        let end = index(startIndex, offsetBy: maxLength)
        return self[..<end] + suffix
    }
}
