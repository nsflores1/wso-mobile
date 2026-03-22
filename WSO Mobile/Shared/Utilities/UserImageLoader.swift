//
//  UserImageLoader.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-03-21.
//

// this function loads an image from the Kingfisher cache and stores it on disk,
// so that it can then be used again. I have encapsulated it here so changes
// to the image system do not break every call site.

import SwiftUI
import Kingfisher
import Logging

struct UserImageLoader: ViewModifier {
    let user: String?
    @Binding var imageData: UIImage?
    @Environment(\.logger) private var logger

    func body(content: Content) -> some View {
        content
            .task(id: user) {
                guard let user else { return }
                let key = "\(user).jpg"

                // check memory
                if let cached = ImageCache.default.retrieveImageInMemoryCache(forKey: key) {
                    imageData = cached
                    return
                }

                // ok, didn't find it. let's check disk
                let diskResult = try? await ImageCache.default.retrieveImage(forKey: key)
                if let diskImage = diskResult?.image {
                    imageData = diskImage
                    return
                }

                // ok, it's nowhere so far. let's fetch it!
                guard let data = try? await WSOGetUserImage(unix: user),
                      let image = UIImage(data: data) else { return }

                imageData = image
                try? await ImageCache.default.store(image, forKey: key, toDisk: true)
            }
    }
}

extension View {
    func loadingUserImage(for user: String?, into binding: Binding<UIImage?>) -> some View {
        modifier(UserImageLoader(user: user, imageData: binding))
    }
}
