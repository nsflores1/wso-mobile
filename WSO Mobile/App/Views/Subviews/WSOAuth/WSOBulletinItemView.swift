//
//  WSOBulletinItemView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-30.
//

import SwiftUI
import Kingfisher
import Logging

struct WSOBulletinItemView: View {
    @Environment(\.logger) private var logger

    let post: WSOBulletinItem
    let viewModel: WSOUserViewModel

    @State private var imageData: UIImage?

    var body: some View {
        let startDate = {
            guard let postStartDate = post.startDate else { return "N/A" }
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, yyyy"
            return displayFormatter.string(from: postStartDate)
        }
        DisclosureGroup {
            VStack {
                Text(post.body)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.leading)
            }
        } label: {
            HStack {
                VStack {
                    if let imageData = imageData {
                        Image(uiImage: imageData)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }  else {
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                VStack {
                    HStack {
                        Text(post.title)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundStyle(Color.accent)
                        Text(startDate())
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.secondary)
                        Spacer()
                    }
                    if viewModel.data != nil {
                        HStack {
                            Image(systemName: "person")
                                .foregroundStyle(Color.accent)
                            Text("\(viewModel.data!.name) (\(viewModel.data!.unixID))")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.secondary)
                            Spacer()
                        }
                    }
                }.padding(.horizontal, 10)
            }
        }
        .swipeActions(edge: .trailing) {
            Button {
                UIPasteboard.general.string = post.body
            } label: {
                Label("Copy", systemImage: "document.on.document")
            }
            .tint(.blue)
        }
        .task {
            await viewModel.fetchIfNeeded()
            // this is so stupid. I can't believe it works
            guard let user = viewModel.data else { return }
            let unixID = user.unixID
            let key = "\(user.id).jpg"

                // check memory
            if let cached = ImageCache.default.retrieveImageInMemoryCache(forKey: key) {
                imageData = cached
                return
            }

                // check disk
            let diskResult = try? await ImageCache.default.retrieveImage(forKey: key)
            if let diskImage = diskResult?.image {
                imageData = diskImage
                return
            }

                // fetch
            guard let data = try? await WSOGetUserImage(unix: unixID),
                  let image = UIImage(data: data) else { return }

            imageData = image
            do {
                try await ImageCache.default.store(image, forKey: key, toDisk: true)
            } catch {
                logger.error("Failed to cache image for Unix \(unixID), WSO ID \(user.id). Error: \(error.localizedDescription)")
            }
        }
    }
}
