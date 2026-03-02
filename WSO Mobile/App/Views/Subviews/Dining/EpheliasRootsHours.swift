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
            ProgressView()
        } else if let err = viewModel.error {
                // THIS STATE MEANS BAD. USERS SHOULD NEVER SEE THIS
            Text(err.localizedDescription).foregroundStyle(Color.red)
        } else {
            NavigationStack {
                List {
                    Section("Description") {
                        Text("A minority-focused convenience store located in the upper floor of Goodrich Hall.")
                    }
                    Section("Hours") {
                        Text("Monday: 9-11AM, 7-10PM")
                        Text("Tuesday: 9:30-11AM, 7-10PM")
                        Text("Wednesday: 7-10PM")
                        Text("Thursday: 7-10PM")
                        Text("Friday: (Closed)")
                        Text("Saturday: (Closed)")
                        Text("Sunday: 10AM-12PM")
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
