//
//  WSOProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-26.
//

// this is for users OTHER than the logged in one. that one has a special
// viewmodel, because we basically NEVER want to deallocate our own login
// the code is MOSTLY copied from ProfileView, but there's enough differences
// to justify splitting them into separate views

import SwiftUI
import System
import Kingfisher
import Shimmer
import Logging

struct WSOProfileView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State var viewModel: WSOUserViewModel
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
                            let key = "\(viewModel.userID).jpg"

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
                                logger.error("Failed to cache image for Unix \(unixID), WSO ID \(viewModel.userID). Error: \(error.localizedDescription)")
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
                            Text("Unix: ").bold() + Text(viewModel.data?.unixID ?? "Loading...").italic() + Text("@williams.edu")
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
                            if let homeTown = viewModel.data?.homeTown {
                                if let homeState = viewModel.data?.homeState {
                                    Text("Hometown: ").bold() + Text("\(homeTown), \(homeState)")
                                }
                            }
                            if viewModel.data?.pronoun?.isEmpty == false {
                                Text("Pronouns: ").bold() + Text(viewModel.data?.pronoun ?? "Loading...")
                            }
                        }
                    }
                } header : {
                    Text("\(viewModel.data?.type.capitalized ?? "User") Profile")
                        .fontWeight(.semibold)
                        .font(.title3)
                }
                Section {
                    Text("The final version will look different than this!").italic()
                }
            }
            .listStyle(.grouped)
            .navigationTitle(Text("Profile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "WSO Mobile version: 1.2.1"))
            .navigationBarTitleDisplayMode(.large)
            .task {
                logger.trace("Fetching user profile \(viewModel.userID)...")
                await viewModel.fetchIfNeeded()
                logger.trace("Fetch complete for user profile \(viewModel.userID)")
            }
            .refreshable {
                logger.trace("User profile \(viewModel.userID) data is being forcibly refreshed...")
                await viewModel.forceRefresh()
                logger.trace("User profile \(viewModel.userID) data forcibly refreshed")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        ShareLink(item: URL(string: "https://wso.williams.edu/facebook/users/\(viewModel.userID)")!) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
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

