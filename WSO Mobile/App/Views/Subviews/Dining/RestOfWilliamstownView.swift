//
//  RestOfWilliamstownView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct RestOfWilliamstownView: View {
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
                    Section("Water Street Grill")
                    {
                        Section
                        {
                            Text("American tavern food.")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://413-458-2175")!)
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("413-458-2175")
                                        .foregroundStyle(.accent)
                                }
                            }
                            Link(destination: URL(string: "https://www.waterstgrill.com")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("waterstgrill.com")
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
                            Text("Daily: 11:30AM-4PM for Lunch, 4PM-9PM for Dinner")
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("A-Frame Bakery")
                    {
                        Section
                        {
                            Text("Bakery selling many types of pastries.")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://413-458-3600")!)
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("413-458-3600")
                                        .foregroundStyle(.accent)
                                }
                            }
                            Link(destination: URL(string: "https://www.facebook.com/AFrameBakery/")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("facebook.com")
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
                            Text("Monday-Wednesday: (Closed)")
                            Text("Thursday-Friday: 8AM-4PM")
                                .listRowSeparator(.hidden)
                            Text("Saturday-Sunday: 8:30AM-9PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Coyote Flaco Restaurant")
                    {
                        Section
                        {
                            Text("Mexican and Spanish dinner.")
                            Button(action: {
                                UIApplication.shared.open(URL(string: "tel://413-458-4240")!)
                            }) {
                                HStack {
                                    Image(systemName: "phone")
                                    Text("413-458-4240")
                                        .foregroundStyle(.accent)
                                }
                            }
                            Link(destination: URL(string: "https://www.facebook.com/coyoteflaco")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("facebook.com")
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
                            Text("Monday-Tuesday: (Closed)")
                            Text("Wednesday-Thursday: 4PM-9PM")
                                .listRowSeparator(.hidden)
                            Text("Friday-Saturday: 4PM-10PM")
                                .listRowSeparator(.hidden)
                            Text("Sunday: 4PM-9PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Mezze Bistro + Bar")
                    {
                        Section
                        {
                            Text("Mediterranean upscale multi-course dinner.")
                            Link(destination: URL(string: "https://www.mezzerestaurant.com")!)
                            {
                                HStack {
                                    Image(systemName: "network")
                                    Text("mezzerestaurant.com")
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
                            Text("Wednesday-Sunday: 5PM-8:30PM")
                            Text("Other times possible; need to reserve")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                }
                .navigationTitle(Text("Rest of Williamstown"))
            }
        }
    }
}

#Preview {
    RestOfWilliamstownView()
}
