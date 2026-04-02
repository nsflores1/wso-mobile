//
//  NavStackShim.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-30.
//

import SwiftUI

// .navigationSubtitle() is nice but only runs on iOS 26 or newer.
// for iOS 18 users, this shim alows it to only run on the selected version.
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

extension View {
    func navSubtitleIfAvailable(_ value: String) -> some View {
        modifier(NavSubtitleIfAvailable(subtitle: value))
    }
}

// this allows you to quickly set haptic feedback, since Apple's wrapper
// is a bit verbose than is needed for our use case.
struct HapticTap: ViewModifier {
    let haptic: UIImpactFeedbackGenerator.FeedbackStyle

    @ViewBuilder
    func body(content: Content) -> some View {
        content.simultaneousGesture(TapGesture().onEnded {
            UIImpactFeedbackGenerator(style: haptic).impactOccurred()
        })
    }
}

extension View {
    func hapticTap(_ value: UIImpactFeedbackGenerator.FeedbackStyle) -> some View {
        modifier(HapticTap(haptic: value))
    }
}

// this is a helper that makes it trivially easy to make a view copy-paste!
// to use on a view:
// Text(thing.text)
//  .copyable(thing.text)

// TODO: extend this so way more views use this
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

