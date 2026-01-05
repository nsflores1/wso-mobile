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
    @State private var selected: Date?
    @State private var showPicker = false
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
                    // TODO: need a button here that selects the day we want
                    Section {
//                        if viewModel.pastList != [] {
//                            DisclosureGroup(
//                                isExpanded: $showPicker,
//                                content: {
//                                    Picker("Date", selection: $selected) {
//                                        ForEach(viewModel.pastList, id: \.self) { date in
//                                            Text(date, format: .dateTime.year().month().day())
//                                                .tag(Optional(date))
//                                        }
//                                    }
//                                    .pickerStyle(.wheel)
//                                    .frame(maxWidth: .infinity)
//                                },
//                                label: {
//                                    if let date = selected {
//                                        Text(date, format: .dateTime.year().month().day())
//                                            .italic(true)
//                                    } else {
//                                        Text("(Click to select a different day...)")
//                                            .foregroundStyle(Color(.secondaryLabel))
//                                            .italic()
//                                    }
//                                }
//                            )
//                        }
                        ForEach(
                            viewModel.diningMenu.sorted(),
                            id: \.hallName
                        ) { hall in
                            NavigationLink(destination: DiningVendorView(menu: hall)) {
                                HStack {
                                    Circle()
                                        .fill(hall.isOpenNow(now: normalizedNowMinutes()) ? .green : .red)
                                        .frame(width: 10, height: 10)
                                    }
                                    Text(hall.hallName)
                                    if hall.hasCoursesToday() {
                                        Text("(Not serving today)")
                                            .foregroundStyle(Color(.secondaryLabel))
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

    // this stops assuming a day around the cutoff, which is important for avoiding
    // all sorts of weird time bugs that would otherwise happen around 4am
    func normalizedNowMinutes(cutoffHour: Int = 5) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.hour, .minute], from: Date())
        let hour = comps.hour!
        let minute = comps.minute!

        let raw = hour * 60 + minute
        let cutoff = cutoffHour * 60

        return raw < cutoff ? raw + 24 * 60 : raw
    }

}

#Preview {
    DiningView()
}
