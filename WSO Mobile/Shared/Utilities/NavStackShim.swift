//
//  NavStackShim.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-30.
//

// .navigationSubtitle() is nice but only runs on iOS 26 or newer.
// for iOS 18 users, this shim alows it to only run on the selected version.

import SwiftUI

struct NavSubtitleIfAvailable: ViewModifier {
    let subtitle: String

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.navigationSubtitle(Text(subtitle))
        } else {
            content
        }
    }
}
