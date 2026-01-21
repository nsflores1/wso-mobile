//
//  ReviewRequest.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-21.
//

// abstraction that calls the StoreKit API and fetches a review prompt
// Apple does not like this to be called often and this code is kinda ugly
// and doesn't fit elsewhere, so I'm punting it into this weird file

import StoreKit
import Foundation

func requestReview() {
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        AppStore.requestReview(in: scene)
    }
}

