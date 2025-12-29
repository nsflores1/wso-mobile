//
//  DiningView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI
import Logging

struct DiningView: View {
    @Environment(\.logger) private var logger
    @State private var viewModel = DiningHoursViewModel()
    @AppStorage("hatesEatingOut") var hatesEatingOut: Bool = false

    var body: some View {
        NavigationStack {
            if viewModel.isLoading && viewModel.diningMenu.isEmpty {
                ProgressView()
                .navigationTitle(Text("Dining"))
            } else if let err = viewModel.error {
                Group {
                    Text(err.localizedDescription).foregroundStyle(Color.red)
                        .navigationTitle(Text("Dining"))
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
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
                    Section {
                        ForEach(
                            viewModel.diningMenu.sorted(),
                            id: \.hallName
                        ) { hall in
                            NavigationLink(destination: DiningVendorView(menu: hall)) {
                                HStack {
                                    Text(hall.hallName)
                                        // TODO: some way to track hall status here. is it open? is it closed?
                                        // consider parsing everything as a date.
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
                        logger.trace("Dining data is being forcibly refreshed...")
                        await viewModel.forceRefresh()
                        logger.trace("Dining data forcibly refreshed")
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                .navigationTitle(Text("Dining"))
                .modifier(NavSubtitleIfAvailable(subtitle: "Halls and other places"))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            NavigationLink(destination: DiningKeyView()) {
                                Image(systemName: "questionmark")
                            }.simultaneousGesture(TapGesture().onEnded {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            })
                        }
                    }
                }
            }
        }.task {
            logger.trace("Fetching dining data...")
            await viewModel.fetchIfNeeded()
            logger.trace("Fetch complete")
        }
    }
}

#Preview {
    DiningView()
}
