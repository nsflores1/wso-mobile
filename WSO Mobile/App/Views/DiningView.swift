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
    @StateObject private var state = ContentViewModel()

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
                        if (state.localEater == false) {
                            Section {
                                NavigationLink("Ephelia's Roots") {
                                        // TODO: write this view
                                }
                                NavigationLink("Tunnel City") {
                                    SpringStreetRestaurantView()
                                }
                                NavigationLink("Tea and Boba Lounge") {
                                    SpringStreetRestaurantView()
                                }
                                NavigationLink("Spring Street Restaurants") {
                                    SpringStreetRestaurantView()
                                }
                                NavigationLink("Rest of Williamstown") {
                                        // TODO: write this view
                                }
                            } header: {
                                Text("Off-Campus & Stores")
                                    .fontWeight(.semibold)
                                    .font(.title3)
                            }
                        }
                        DiningVendorView(menu: viewModel.diningMenu)
                    }
                    .navigationTitle(Text("Dining"))
                }


        }.task { await viewModel.loadMenus() }
    }
}

#Preview {
    DiningView().environmentObject(AppSettings.shared)
}
