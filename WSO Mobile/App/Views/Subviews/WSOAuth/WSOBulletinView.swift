//
//  WSOBulletinListView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-30.
//

import SwiftUI
import Logging

struct WSOBulletinListView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    @State private var viewModel = WSOBulletinViewModel()

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
                        .navigationTitle("Bulletins")
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                List {
                    DisclosureGroup {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.announcementsPreview) { bulletin in
                                WSOBulletinItemView(
                                    post: bulletin,
                                    viewModel: WSOUserViewModel(userID: bulletin.userID)
                                )
                            }
                            NavigationLink(
                                destination: WSOBulletinPerListView(
                                    type: "announcement",
                                    prettyString: "Announcements"
                                )
                            ) {
                                Text("View more posts...").italic()
                            }
                        }
                    } label : {
                        HStack {
                            Text("Announcements")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "megaphone")
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.announcementsPreview.count)
                    DisclosureGroup {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.exchangePreview) { bulletin in
                                WSOBulletinItemView(
                                    post: bulletin,
                                    viewModel: WSOUserViewModel(userID: bulletin.userID)
                                )
                            }
                            NavigationLink(
                                destination: WSOBulletinPerListView(
                                    type: "exchange",
                                    prettyString: "Exchanges"
                                )
                            ) {
                                Text("View more posts...").italic()
                            }
                        }
                    } label : {
                        HStack {
                            Text("Exchanges")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "gift")
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.exchangePreview.count)
                    DisclosureGroup {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.jobsPreview) { bulletin in
                                WSOBulletinItemView(
                                    post: bulletin,
                                    viewModel: WSOUserViewModel(userID: bulletin.userID)
                                )
                            }
                            NavigationLink(
                                destination: WSOBulletinPerListView(
                                    type: "job",
                                    prettyString: "Jobs"
                                )
                            ) {
                                Text("View more posts...").italic()
                            }
                        }
                    } label : {
                        HStack {
                            Text("Jobs")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.jobsPreview.count)
                    DisclosureGroup {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(viewModel.lostandfoundPreview) { bulletin in
                                WSOBulletinItemView(
                                    post: bulletin,
                                    viewModel: WSOUserViewModel(userID: bulletin.userID)
                                )
                            }
                            NavigationLink(
                                destination: WSOBulletinPerListView(
                                    type: "lostAndFound",
                                    prettyString: "Lost & Found"
                                )
                            ) {
                                Text("View more posts...").italic()
                            }
                        }
                    } label : {
                        HStack {
                            Text("Lost & Found")
                                .font(.title3)
                            Spacer()
                            Image(systemName: "suitcase")
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.lostandfoundPreview.count)
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
                            }.simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            })
                        }
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Bulletins")
                .modifier(NavSubtitleIfAvailable(subtitle: "College discussion lists"))
            }
        }
    }
}

struct WSOBulletinPerListView: View {
    let type: String
    let prettyString: String
    @State var viewModel = WSOBulletinViewModel()
    @State private var searchText = ""

    var body: some View {
        var searchResults: [WSOBulletinItem] {
            if searchText.isEmpty {
                return viewModel.data.filter {
                    $0.type == type
                }
            } else {
                    // check the body and title, but first filter by type
                return viewModel.data.filter {
                    $0.type == type &&
                    $0.body.contains(searchText)
                    || $0.title.contains(searchText)
                }
            }
        }
        NavigationStack {
            List {
                ForEach(searchResults) { bulletin in
                    WSOBulletinItemView(
                        post: bulletin,
                        viewModel: WSOUserViewModel(userID: bulletin.userID)
                    )
                }
            }
            .animation(.easeInOut(duration: 0.25), value: searchText.isEmpty)
            .animation(.easeInOut(duration: 0.2), value: searchResults.count)
            .searchable(text: $searchText)
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
                        }.simultaneousGesture(TapGesture().onEnded {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                    }
                }
            }
            .navigationTitle(Text(prettyString))
            .modifier(NavSubtitleIfAvailable(subtitle: "Posts on the \(prettyString) bulletin"))
        }
    }
}

struct WSOBulletinItemView: View {
    @Environment(\.logger) private var logger

    let post: WSOBulletinItem
    @State var viewModel: WSOUserViewModel
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
        }
        .loadingUserImage(for: viewModel.data?.unixID, into: $imageData)
    }
}

struct WSOBulletinKeyView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    let introText = """
                    Bulletins is a feature which displays useful messages for the Williams College campus community.
                    """
                    Text(introText.replacingOccurrences(of: "\n", with: " "))
                }
                Section {
                    let explanationText = """
                    Each section reflects a different kind of bulletin that you can access. Rides and discussions have special properties and thus are not shown here, despite being presented alongside all the other bulletins on the web version.
                    """
                    Text(explanationText.replacingOccurrences(of: "\n", with: " "))
                    let explanationText2 = """
                    Bulletins may take a second to load as the app fetches all bulletins available on the server (so that you can browse them offline if you would like). The same applies for search; it may take a second or two to load search results, depending on how old your iPhone is along with other factors.
                    """
                    Text(explanationText2.replacingOccurrences(of: "\n", with: " "))
                }
            }
            .navigationTitle("Bulletins Help")
            .modifier(NavSubtitleIfAvailable(subtitle: "For all your bulletin related needs"))
        }

    }
}

#Preview {
    WSOBulletinListView()
}
