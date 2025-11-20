//
//  SpringStreetRestaurantView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Combine

struct SpringStreetRestaurantView: View {
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
            Section {
                Text("hoi!!! I'm a view!!!")
            } header: {
                Text("Spring Street Hours")
                    .fontWeight(.semibold)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    DiningView().environmentObject(AppSettings.shared)
}
