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
                if viewModel.isLoading {
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
                        DiningVendorView(menu: viewModel.diningMenu)
                    }
                    .navigationTitle(Text("Dining"))
                    .navigationSubtitle(Text("Halls and other places"))
                }


        }.task { await viewModel.loadMenus() }
    }
}

#Preview {
    DiningView()
}
