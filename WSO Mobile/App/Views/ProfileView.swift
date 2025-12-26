//
//  ProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import System
import Kingfisher

struct ProfileView: View {
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSOUserViewModel()
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
                            Text("(Class of \(viewModel.data?.classYear.description ?? "(N/A)"))").italic()
                        }
                    }.frame(maxWidth: .infinity, alignment: .center)
                    VStack(alignment: .leading) {
                        Section {
                            Text("Unix: ").bold() + Text(viewModel.data?.unixID ?? "Loading...").italic() + Text("@williams.edu")
                            Text("Tags: ").bold() + Text(viewModel.data?.tags.compactMap(\.name).joined(separator: ", ") ?? "(No tags)")
                            if let suBox = viewModel.data?.suBox {
                                Text("SU Box: ").bold() + Text(suBox)
                            }
                            if let homeTown = viewModel.data?.homeTown {
                                if let homeState = viewModel.data?.homeState {
                                    Text("Hometown: ").bold() + Text("\(homeTown), \(homeState)")
                                }
                            }
                            Text("Pronouns: ").bold() + Text(viewModel.data?.pronoun ?? "Loading...")
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
            .task { await viewModel.fetchIfNeeded() }
            .refreshable {
                await viewModel.forceRefresh()
            }
        }
    }
}

#Preview {
    ProfileView()
}
