//
//  WCFMShowsView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-25.
//

import SwiftUI
import Combine

struct WCFMShowsView: View {
        // TODO: give this a new state model
    @StateObject private var viewModel = WCFMViewModel()

    var body: some View {
        Section {
            VStack {
                Text("Come back again later!")
            }.padding(16)
        } header: {
            Text("WCFM Shows")
                .fontWeight(.semibold)
                .font(.title3)
        }
    }
}

#Preview {
    WCFMView()
}
