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
                Text("Some functionality doesn't work in this Beta version (v0.0.1):")
                let mainText = """
                    
                    - Literally anything that involves the WSO backend (FaceBook, FacTrak, etc)
                    - Dining (broken on backend)
                    - Embedded pictures in Record articles
                    - Links in Daily Messages posts
                    - Off-campus dining location hours don't update automatically (broken on backend)
                    
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
