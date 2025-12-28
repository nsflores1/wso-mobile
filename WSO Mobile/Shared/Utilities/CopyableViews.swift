//
//  CopyableViews.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-28.
//

// this is a helper that makes it trivially easy to make a view copy-paste!
// to use on a view:
// Text(thing.text)
//  .copyable(thing.text)

// TODO: extend this so way more views use this
// ...although this requires making a ToString() for all of them

import SwiftUI

struct Copyable: ViewModifier {
    let value: String

    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button("Copy") {
                    UIPasteboard.general.string = value
                }
            }
    }
}

extension View {
    func copyable(_ value: String) -> some View {
        modifier(Copyable(value: value))
    }
}
