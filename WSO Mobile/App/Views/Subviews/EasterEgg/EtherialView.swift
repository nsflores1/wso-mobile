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
                    Text("""
                        Hey, you! Thanks for making it here, to the end of the app.
                        
                        I hope you like using this app as much as I liked writing it! It was a lot of fun to develop complex software that people will end up using every day. If you've got anything you want to say about the app, I'd love to hear it. 
                        
                        This whole project is made out of a great appreciation for the excellent community at Williams, and I encourage you all to help keep it as amazing as it has always been!
                        
                        So long, and thanks for all the Driscoll salmon! :D
                        
                        - Nathaniel Flores, class of '27 (nsf1@williams.edu)
                        """)
                        .italic(true)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(5)
                }.padding(20)
            }
            .navigationTitle(Text("Thank You!"))
        }.padding(20)
    }
}

#Preview {
    EtherialView()
}
