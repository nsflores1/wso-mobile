//
//  HomeCardView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

import SwiftUI
import Kingfisher
import Logging
import Shimmer

struct HomeCardView: View {
    @Environment(\.logger) private var logger

    let user: User

    @State private var imageData: UIImage?

    var body: some View {
        NavigationLink(destination: WSOProfileView(viewModel: WSOUserViewModel(userID: user.id))) {
            HStack {
                VStack {
                    if let imageData = imageData {
                        Image(uiImage: imageData)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }  else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                VStack() {
                    HStack {
                        Text(user.name)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundStyle(Color.accent)
                        Text(user.unixID)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.secondary)
                            .italic()
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(Color.accent)
                        if user.admin {
                            // assuming WSO admins are always students
                            Text("WSO Admin, \(user.classYear!.description)")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color.secondary)
                                .italic()
                                .shimmering()
                        } else {
                            if user.classYear != nil {
                                Text("\(user.type.capitalized), \(user.classYear!.description)")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(Color.secondary)
                                    .italic()
                            } else {
                                Text(user.type.capitalized)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(Color.secondary)
                                    .italic()
                            }
                        }
                        Spacer()
                    }
                }.padding(.horizontal, 10)
            }
        }
        .task(id: user.unixID) {
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

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
