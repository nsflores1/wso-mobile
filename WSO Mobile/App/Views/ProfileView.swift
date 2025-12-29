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
    @State private var imageData: Data?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack {
                        Group {
                            if let data = imageData {
                                if let unixID = viewModel.data?.unixID {
                                    KFImage(
                                        source:
                                            .provider(
                                                RawImageDataProvider(
                                                    data: data,
                                                    cacheKey: "\(unixID).jpg"
                                                )
                                            )
                                    )
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .frame(width: 200, height: 200)
                                }
                            } else {
                                ProgressView()
                                    .frame(width: 200, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }.task(id: viewModel.data?.unixID) {
                            if let unixID = viewModel.data?.unixID {
                                imageData = try? await WSOGetUserImage(unix: unixID)
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
                    Text("Your Profile")
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
                logger.info("Fetching user's personal profile...")
                await viewModel.fetchIfNeeded()
                logger.info("Fetch complete")
            }
            .refreshable {
                logger.info("User's personal profile data is being forcibly refreshed...")
                await viewModel.forceRefresh()
                logger.info("User's personal profile data forcibly refreshed")
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
