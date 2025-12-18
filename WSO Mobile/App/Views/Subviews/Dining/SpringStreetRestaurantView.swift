//
//  SpringStreetRestaurantView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI

struct SpringStreetRestaurantView: View {
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
                // TODO: this should just be parsing a JSON at some point!
                List {
                    Section("Blue Mango")
                    {
                        Section
                        {
                            Text("Thai and Japanese lunch and dinner.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday-Sunday: 11:30AM-9:30PM")
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Pappa Charlie's Deli")
                    {
                        Section
                        {
                            Text("Sandwiches, soups, and salads.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Daily: 9AM-4PM")
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Crust")
                    {
                        Section
                        {
                            Text("Pizzas and salads.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday: 11:30AM-8PM")
                            Text("Tuesday: (Closed)")
                                .listRowSeparator(.hidden)
                            Text("Wednesday-Thursday: 11:30AM-8PM")
                                .listRowSeparator(.hidden)
                            Text("Friday: 11:30AM-8:30PM")
                                .listRowSeparator(.hidden)
                            Text("Saturday: 12PM-8:30PM")
                                .listRowSeparator(.hidden)
                            Text("Sunday: 12PM-8PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Spice Root")
                    {
                        Section
                        {
                            Text("Modern Indian lunch and dinner.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Tuesday-Saturday: 11:30AM-2:30PM, 5PM-10PM")
                            Text("Sunday: 12PM-3PM, 5PM-10PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("The Log by Ramunto's")
                    {
                        Section
                        {
                            Text("Pizzeria and American-style dinner. Also the place for Trivia Nights.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday-Tuesday: (Closed)")
                            Text("Wednesday: 3PM-8PM")
                                .listRowSeparator(.hidden)
                            Text("Thursday: 12PM-2PM, 4PM-9PM")
                                .listRowSeparator(.hidden)
                            Text("Friday-Sunday: 3PM-9PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Tony's Sombrero")
                    {
                        Section
                        {
                            Text("Mexican lunch and dinner.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday-Saturday: 11AM-9PM")
                            Text("Sunday: (Closed)")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Purple Pub")
                    {
                        Section
                        {
                            Text("American pub.")
                            Text("Note: Purple Pub is likely closed for the forseeable future.").italic()
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday-Tuesday: (Closed)")
                            Text("Wednesday-Saturday: 11:30AM-9PM")
                                .listRowSeparator(.hidden)
                            Text("Sunday: 11:30AM-4PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                    Section("Plates Mediterranean Bistro")
                    {
                        Section
                        {
                            Text("Mediterranean cuisine.")
                        } header : {
                            Text("Description")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                        Section
                        {
                            Text("Monday: 11AM-9PM")
                            Text("Tuesday: 11AM-3PM, 4PM-9PM")
                                .listRowSeparator(.hidden)
                            Text("Wednesday: 4PM-9PM")
                                .listRowSeparator(.hidden)
                            Text("Thursday-Sunday: 11AM-3PM, 4PM-9PM")
                                .listRowSeparator(.hidden)
                        } header : {
                            Text("Hours")
                                .italic()
                                .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                                .listRowBackground(Color.accent)
                        }
                    }
                }
                .navigationTitle(Text("Spring Street"))
            }
        }
    }
}

#Preview {
    SpringStreetRestaurantView()
}
