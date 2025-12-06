//
//  EtherialView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-29.
//

// documentation: https://github.com/Cindori/FluidGradient

import SwiftUI
import FluidGradient

struct EtherialView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // TODO: this could lowkey be the new onboarding screen
                FluidGradient(
                    blobs: [
                        Color(hue: 0.56, saturation: 0.8, brightness: 0.9),
                        Color(hue: 0.52, saturation: 0.7, brightness: 0.85),
                        Color(hue: 0.66, saturation: 0.55, brightness: 0.85)
                    ],
                    highlights: [
                        Color(hue: 0.58, saturation: 0.9, brightness: 1.0),
                        Color(hue: 0.68, saturation: 0.75, brightness: 1.0),
                        Color(hue: 0.74, saturation: 0.6, brightness: 0.95)
                    ],
                    speed: 0.5,
                    blur: 0.75
                )
                .background(.quaternary)
                .cornerRadius(20)
                VStack {
                    Text("\"Do not think you will be aware of your own enlightenment.\"\n - Dōgen")
                        .italic(true)
                        .padding(20)
                        .background(.ultraThinMaterial, in: Capsule())
                    NavigationLink("A secret for math enjoyers!") {
                        EasterEggView()
                    }
                    .buttonStyle(.borderedProminent)
                }.padding(20)
            }
            .navigationTitle(Text("The Ether"))
        }.padding(20)
    }
}

#Preview {
    EtherialView()
}
