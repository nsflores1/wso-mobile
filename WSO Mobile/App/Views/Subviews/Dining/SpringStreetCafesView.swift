//
//  SpringStreetCafesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Combine

struct SpringStreetCafesView: View {
        // TODO: give this a new state model
    @StateObject private var viewModel = DiningHoursViewModel()

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
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Tuesday-Saturday: 8AM-5PM, kitchen closes at 4PM")
                            Text("Sunday: 9AM-3PM, kitchen closes at 2:30PM")
                            Text("Monday: (Closed)")
                        } header : {
                            Text("Hours")
                                .italic()
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
                        }
                        Section
                        {
                            Text("Monday-Saturday: 11AM-5PM")
                            Text("Sunday: 12PM-5PM")
                        } header : {
                            Text("Hours")
                                .italic()
                        }
                    }
                    Section("Tunnel City")
                    {
                        Section
                        {
                            Text("Coffee, pastries, and breakfast.")
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Friday-Sunday: 6AM-5PM")
                            Text("Monday-Thursday: 6AM-4PM")
                        } header : {
                            Text("Hours")
                                .italic()
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
