//
//  ProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import System
import Kingfisher
import Shimmer
import Logging

struct ProfileView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSOSelfUserViewModel()
    @State private var imageData: UIImage?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        Group {
                            if let image = imageData {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .frame(width: 200, height: 200)
                            } else {
                                ProgressView()
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }.task(id: viewModel.data?.unixID) {
                            guard let unixID = viewModel.data?.unixID else { return }
                            let key = "\(unixID).jpg"

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
                                logger.error("Failed to cache image for \(unixID): \(error.localizedDescription)")
                            }
                        }
                        HStack {
                            Text(viewModel.data?.name ?? "Loading...").bold()
                            if viewModel.data?.type == "staff" {
                                Text("(Staff)").italic()
                            } else if viewModel.data?.type == "professor" {
                                Text("(Professor)").italic()
                            } else if viewModel.data?.type == "student" {
                                Text("(Class of \(viewModel.data?.classYear?.description ?? "(N/A)"))").italic()
                            }
                        }
                        if let admin = viewModel.data?.admin {
                            if admin { Text("WSO Administrator").shimmering() }
                        }
                        if viewModel.data?.type == "staff" || viewModel.data?.type == "professor" {
                            if let title = viewModel.data?.title {
                                Text(title).font(.headline)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    VStack(alignment: .leading) {
                        Section {
                            Text("Unix: ").bold() + Text(viewModel.data?.unixID ?? "...").italic() + Text("@williams.edu")
                            if let department = viewModel.data?.department {
                                Text("Department: ").bold() + Text(department.name)
                            }
                            if let office = viewModel.data?.office {
                                Text("Office: ").bold() + Text(office.number)
                            }
                            if viewModel.data?.type == "student" {
                                Text("Tags: ")
                                    .bold() + Text(
                                        viewModel.data?.tags?
                                            .compactMap(\.name)
                                            .joined(separator: ", ") ?? "(No tags)"
                                    )
                            }
                            if let suBox = viewModel.data?.suBox {
                                Text("SU Box: ").bold() + Text(suBox)
                            }
                            // some shenanigains with the hometown.
                            // swift really doesn't like conditional text,
                            // but this is a nice functional way of handling it.
                            let parts: [Text] = [
                                viewModel.data?.homeTown.map {
                                    Text("Hometown: ").bold() + Text($0)
                                },
                                viewModel.data?.homeState.map {
                                    Text(", \($0)")
                                },
                                viewModel.data?.homeCountry.map {
                                    Text(", \($0)")
                                }
                            ].compactMap { $0 }
                            // this shows the hometown by checking if we're allowed to
                            if let showHome = viewModel.data?.homeVisible {
                                if showHome { parts.reduce(Text(""), +) }
                            }
                            if viewModel.data?.pronoun?.isEmpty == false {
                                Text("Pronouns: ").bold() + Text(viewModel.data?.pronoun ?? "Loading...")
                            }
                        }
                    }
                } header : {
                    Text("Your Profile")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
            .listStyle(.grouped)
            .navigationTitle(Text("Profile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "WSO Mobile version: 1.2.1"))
            .navigationBarTitleDisplayMode(.large)
            .task {
                logger.trace("Fetching user's personal profile...")
                await viewModel.fetchIfNeeded()
                logger.trace("Fetch complete")
            }
            .refreshable {
                logger.trace("User's personal profile data is being forcibly refreshed...")
                await viewModel.forceRefresh()
                logger.trace("User's personal profile data forcibly refreshed")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        // TODO: ADD EDIT CAPABILITIES
                        Label("Share", systemImage: "square.and.pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
