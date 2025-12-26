//
//  FontExtension.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-25.
//

// this is for the Record article viewer,
// but much of this code could be elegantly reused for other dumb font things

import SwiftUI

extension Font {
    static func garamond(_ textStyle: Font.TextStyle) -> Font {
        // Use the internal name of your font file
        let name = "ebgaramond-Regular"
        // Get the exact point size for the current text style
        let size = UIFont.preferredFont(forTextStyle: textStyle.toUIFontTextStyle()).pointSize
        // Return the custom font sized and scaled just like system text
        return .custom(name, size: size, relativeTo: textStyle)
        // so then you can just
        // Text("some text")
        // .font(.garamond(.body))
        // and it just works!
    }
}

extension Font.TextStyle {
    func toUIFontTextStyle() -> UIFont.TextStyle {
        switch self {
            case .largeTitle: return .largeTitle
            case .title: return .title1
            case .title2: return .title2
            case .title3: return .title3
            case .headline: return .headline
            case .body: return .body
            case .callout: return .callout
            case .subheadline: return .subheadline
            case .footnote: return .footnote
            case .caption: return .caption1
            case .caption2: return .caption2
            @unknown default: return .body
        }
    }
}
