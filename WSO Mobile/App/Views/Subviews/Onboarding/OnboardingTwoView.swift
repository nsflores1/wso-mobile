//
//  OnboardingTwoView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-27.
//

import SwiftUI

struct OnboardingTwoView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Some functionality doesn't work in this version (1.2.1):")
                let mainText = """
                    
                    - Select WSO services (FacTrak, Facebook, BookTrak)
                    - Links in Daily Messages posts
                    
                    """
                Text(mainText)
                    .multilineTextAlignment(.leading)
                Text("We are aware of these issues and are working on them. Please report any issues or suggestions NOT on this list!")
                Spacer()
            }.padding(20)
                .navigationTitle(Text("Known Issues"))
        }.padding(20)
    }
}

#Preview {
    OnboardingTwoView()
}
