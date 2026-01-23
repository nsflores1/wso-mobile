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
                            HStack {
                                Text("Unix:").bold()
                                let email = "\(viewModel.data?.unixID ?? "Loading...")@williams.edu"
                                let url = URL(string: "mailto:\(email)")!
                                Button {
                                    openURL(url)
                                } label: {
                                    Text(email)
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(.accent)
                            }
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
                            // this shows the hometown by checking if we're allowed to
                            if viewModel.data?.homeVisible != nil && viewModel.data?.homeVisible == true  {
                                let locationString = [
                                    viewModel.data?.homeTown,
                                    viewModel.data?.homeState,
                                    viewModel.data?.homeCountry
                                ]
                                    .compactMap { $0 }
                                    .joined(separator: ", ")

                                let encoded = locationString.addingPercentEncoding(
                                    withAllowedCharacters: .urlQueryAllowed
                                )

                                let url = URL(
                                    string: "http://maps.apple.com/?q=\(encoded ?? "")"
                                )!

                                if !locationString.isEmpty {
                                    HStack {
                                        Text("Hometown:").bold()
                                        Button {
                                            openURL(url)
                                        } label: {
                                            Text(locationString)
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(.accent)
                                    }
                                }
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
                if #unavailable(iOS 26) {
                    Section {
                        Text("\(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")")
                    } header: {
                        Text("Last Updated")
                            .fontWeight(.semibold)
                            .font(.title3)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationTitle(Text("Profile"))
            .modifier(NavSubtitleIfAvailable(subtitle: "Last updated: \(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")"))
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task {
                    // give a refresh a try, since we've succeeded, it can't hurt
                    // this will artificially make it feel like it's longer until next refresh
                    let _ = try await authManager.refreshToken()
                }
            }
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
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    HStack {
//                        // TODO: ADD EDIT CAPABILITIES
//                        Label("Share", systemImage: "square.and.pencil")
//                    }
//                }
//            }
        }
    }
}

#Preview {
    ProfileView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
