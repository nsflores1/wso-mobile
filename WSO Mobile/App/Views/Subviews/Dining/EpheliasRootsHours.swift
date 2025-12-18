//
//  EpheliasRootsHours.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct EpheliasRootHoursView: View {
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
                    Section("Description") {
                        Text("A minority-focused convenience store located in the upper floor of Goodrich Hall.")
                    }
                    Section("Hours") {
                        Text("Monday: 7PM-10PM")
                        Text("Tuesday: 7PM-10PM")
                        Text("Wednesday: (Closed)")
                        Text("Thursday: 7PM-10PM")
                        Text("Friday: (Closed)")
                        Text("Saturday: (Closed)")
                        Text("Sunday: 9AM-11AM")
                    }
                }
                .navigationTitle(Text("Ephelia's Roots"))
            }
        }
    }
}

#Preview {
    EpheliasRootHoursView()
}
