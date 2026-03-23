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
                    Text(err.localizedDescription)
                        .foregroundStyle(Color.red)
                    Text("""
                        
                        With searching comes loss
                        and the presence of absence:
                        Menu not found.
                        """)
                        .navigationTitle(Text("Dining"))
                }.refreshable {
                    await viewModel.forceRefresh()
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }.padding(20)
            } else {
                // ALL dining hours stuff lives in here,
                // not just the dining hall ones.
                List {
                    // subtitles not shown in iOS 26, so present timestamp another way
                    if #unavailable(iOS 26) {
                        Section {
                            Text("\(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")")
                        } header: {
                            Text("Last Updated")
                                .fontWeight(.semibold)
                                .font(.title3)
                        }
                    }
                    ForEach(
                        viewModel.diningMenu.sorted(),
                        id: \.hallName
                    ) { hall in
                        if hall.lacksCoursesToday() {
                            Section {
                                DiningVendorView(menu: hall)
                            } header: {
                                Group {
                                    HStack {
                                        Circle()
                                            .fill(hall.isOpenNow(now: normalizedNowMinutes()) ? .green : .red)
                                            .frame(width: 15, height: 15)
                                    }
                                    Text(hall.hallName)
                                }.font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
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
                }.listStyle(.sidebar)
                .refreshable {
                        logger.trace("Dining data is being forcibly refreshed...")
                        await viewModel.forceRefresh()
                        logger.trace("Dining data forcibly refreshed")
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
                .navigationTitle(Text("Dining"))
                .modifier(
                    NavSubtitleIfAvailable(
                        subtitle: "Last updated: \(viewModel.lastUpdated?.shortDisplay ?? "(Not yet updated)")"
                    )
                )
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack {
                            NavigationLink(destination: DiningKeyView()) {
                                Image(systemName: "questionmark")
                            }.hapticTap(.light)
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
