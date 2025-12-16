//
//  DiningView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

// TODO: Ephelia's Roots wants their info here
// TODO: places in town would be sick to have

struct DiningView: View {
    @StateObject private var viewModel = DiningHoursViewModel()
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false

    var body: some View {
        NavigationStack {
            if viewModel.isLoading && viewModel.diningMenu.isEmpty {
                        // TODO: make a nicer ProgressView()
                    Text("Loading...")
                    .navigationTitle(Text("Dining"))
                    // TODO: setting this three times is DUMB but whatevs
                } else if let error = viewModel.errorMessage {
                        // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
                    Text(error).foregroundStyle(Color.red)
                    .navigationTitle(Text("Dining"))
                } else {
                    // ALL dining hours stuff lives in here,
                    // not just the dining hall ones.
                    List {
                        if (hatesEatingOut == false) {
                            Section {
                                NavigationLink("Ephelia's Roots") {
                                    EpheliasRootHoursView()
                                }
                                NavigationLink("Spring Street Cafes") {
                                    SpringStreetCafesView()
                                }
                                NavigationLink("Spring Street Restaurants") {
                                    SpringStreetRestaurantView()
                                }
                                NavigationLink("Rest of Williamstown") {
                                    RestOfWilliamstownView()
                                }
                            } header: {
                                Text("Off-Campus & Campus Stores")
                                    .fontWeight(.semibold)
                                    .font(.title3)
                            }
                        }
                        // TODO: this data structure can change order,
                        // but it should always be ordered alphabetically.
                        Section {
                            ForEach(
                                viewModel.diningMenu.sorted(),
                                id: \.hallName
                            ) { hall in
                                NavigationLink(destination: DiningVendorView(menu: hall)) {
                                    HStack {
                                        Text(hall.hallName)
                                            // TODO: some way to track hall status here. is it open? is it closed?
                                    }
                                }

                            }
                        } header: {
                            Text("On-Campus Dining Halls")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                    }.listStyle(.sidebar)
                    .refreshable {
                        URLCache.shared.removeCachedResponse(for: URLRequest(url: viewModel.diningURL))
                        await viewModel.forceRefresh()
                    }
                    .navigationTitle(Text("Dining"))
                    .modifier(NavSubtitleIfAvailable(subtitle: "Halls and other places"))
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            // TODO: actually add a KeyView
                            // it will explain what the dining
                            // item keys do so they know how to interpret them
                            HStack {
                                NavigationLink(destination: DiningKeyView()) {
                                    Image(systemName: "questionmark")
                                }
                            }
                        }
                    }
                }
        }.task { await viewModel.fetchIfNeeded() }
    }
}

#Preview {
    DiningView()
}
