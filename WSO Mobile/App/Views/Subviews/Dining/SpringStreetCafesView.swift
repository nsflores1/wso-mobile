//
//  SpringStreetCafesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct SpringStreetCafesView: View {
        // TODO: give this a new state model
    @State private var viewModel = DiningHoursViewModel()

    var body: some View {
        if viewModel.isLoading {
                // TODO: make a nicer ProgressView()
            Text("Loading...")
        } else if let error = viewModel.errorMessage {
                // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
            Text(error).foregroundStyle(Color.red)
        } else {
            NavigationStack {
                List {
                    Section("Spring Street Market & Cafe")
                    {
                        Section
                        {
                            Text("Breakfast and lunch offerings.")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://413-458-6192")!)
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("413-458-6192")
                                        .foregroundStyle(.accent)
                                }
                            }
                            Link(destination: URL(string: "https://www.thespringstreetmarketandcafe.com")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("thespringstreetmarketandcafe.com")
                                        .foregroundStyle(.accent)
                                }
                            }
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Tuesday-Saturday: 8AM-5PM, kitchen closes at 4PM")
                            Text("Sunday: 9AM-3PM, kitchen closes at 2:30PM")
                                .listRowSeparator(.hidden)
                            Text("Monday: (Closed)")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Tea and Boba Lounge")
                    {
                        Section
                        {
                            Text("Tea, coffee, matcha, and boba.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Link(destination: URL(string: "https://www.teaandbobalounge.com")!)
                        {
                            HStack {
                                Image(systemName: "network")
                                Text("teaandbobalounge.com")
                                    .foregroundStyle(.accent)
                            }
                        }
                        Section
                        {
                            Text("Monday-Saturday: 11AM-5PM")
                            Text("Sunday: 12PM-5PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Tunnel City")
                    {
                        Section
                        {
                            Text("Coffee, pastries, and breakfast.")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://413-458-5010")!)
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("413-458-5010")
                                        .foregroundStyle(.accent)
                                }
                            }
                            Link(destination: URL(string: "https://www.tunnelcitycoffee.com")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("tunnelcitycoffee.com")
                                        .foregroundStyle(.accent)
                                }
                            }
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Friday-Sunday: 6AM-5PM")
                            Text("Monday-Thursday: 6AM-4PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                }
                .navigationTitle(Text("Spring Street Cafes"))
            }
        }
    }
}

#Preview {
    SpringStreetCafesView()
}
