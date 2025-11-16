//
//  MapView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-15.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()

    var body: some View {
        NavigationStack {
            Map(initialPosition: viewModel.position)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Map")
                            .font(.largeTitle).bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(.ultraThinMaterial, in: Capsule())
                    }
                }
        }
    }
}

#Preview {
    MapView().environmentObject(AppSettings.shared)
}
