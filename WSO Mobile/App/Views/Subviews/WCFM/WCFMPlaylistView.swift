//
//  WCFMPlaylistView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-25.
//

import SwiftUI
import Combine

struct WCFMPlaylistView: View {
        // TODO: give this a new state model
    @StateObject private var viewModel = WCFMViewModel()

    var body: some View {
        Section {
            Text("hoi!!! I'm a view!!!")
        } header: {
            Text("WCFM Playlist")
                .fontWeight(.semibold)
                .font(.title3)
        }
    }
}

#Preview {
    WCFMView().environmentObject(AppSettings.shared)
}
