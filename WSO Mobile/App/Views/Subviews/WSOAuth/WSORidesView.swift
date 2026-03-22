//
//  WSORidesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-15.
//

import SwiftUI

struct WSORidesView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSORidesViewModel()

    var body: some View {
        NavigationStack {
            if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription)
                        .foregroundStyle(Color.red)
                    Text("""
                        
                        Serious error.
                        All shortcuts have disappeared.
                        Screen. Mind. Both are blank.
                        """)
                        .navigationTitle("Rides")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        ForEach(viewModel.data) { item in
                            WSORidesItemView(
                                post: item,
                                viewModel: WSOUserViewModel(userID: item.userID)
                            )
                        }
                        if viewModel.data.isEmpty {
                            Text("(No rides have been posted)")
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: viewModel.data.count)
            }
        }
        .task {
            await viewModel.fetchIfNeeded()
        }
        .refreshable {
            await viewModel.forceRefresh()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink(destination: WSOBulletinKeyView()) {
                        Image(systemName: "questionmark")
                    }.hapticTap(.light)
                }
            }
        }
        .navigationTitle("Rides")
        .listStyle(.sidebar)
        .modifier(NavSubtitleIfAvailable(subtitle: "College ridesharing"))
    }
}

struct WSORidesItemView: View {
    @Environment(\.logger) private var logger

    let post: WSORidesItem
    @State var viewModel: WSOUserViewModel
    @State private var imageData: UIImage?

    var body: some View {
        let startDate = {
            guard let postDate = post.date else { return "N/A" }
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMM d, yyyy"
            return displayFormatter.string(from: postDate)
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
                    } else {
                        ProgressView()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                VStack {
                    HStack {
                        Text("\(post.source) to \(post.destination) (\(post.offer ? "Offer" : "Request"))")
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
        }
        .loadingUserImage(for: viewModel.data?.unixID, into: $imageData)
    }
}
