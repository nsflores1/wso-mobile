//
//  RestOfWilliamstownView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI
import Combine

struct RestOfWilliamstownView: View {
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
                    Section("Water Street Grill")
                    {
                        Section
                        {
                            Text("American tavern food.")
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Daily: 11:30AM-4PM for Lunch, 4PM-9PM for Dinner")
                        } header : {
                            Text("Hours")
                                .italic()
                        }
                    }
                    Section("A-Frame Bakery")
                    {
                        Section
                        {
                            Text("Bakery selling many types of pastries.")
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Monday-Wednesday: (Closed)")
                            Text("Thursday-Friday: 8AM-4PM")
                            Text("Saturday-Sunday: 8:30AM-9PM")
                        } header : {
                            Text("Hours")
                                .italic()
                        }
                    }
                    Section("Coyote Flaco Restaurant")
                    {
                        Section
                        {
                            Text("Mexican and Spanish dinner.")
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Monday-Tuesday: (Closed)")
                            Text("Wednesday-Thursday: 4PM-9PM")
                            Text("Friday-Saturday: 4PM-10PM")
                            Text("Sunday: 4PM-9PM")
                        } header : {
                            Text("Hours")
                                .italic()
                        }
                    }
                    Section("Mezze Bistro + Bar")
                    {
                        Section
                        {
                            Text("Mediterranean upscale multi-course dinner.")
                        } header : {
                            Text("Description")
                                .italic()
                        }
                        Section
                        {
                            Text("Wednesday-Sunday: 5PM-8:30PM")
                            Text("Other times possible; need to reserve")
                        } header : {
                            Text("Hours")
                                .italic()
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
