//
//  SoftwareLicenseView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

struct SoftwareLicenseView: View {
    var body: some View {
        NavigationStack {
            SoftwareLicenseTextView()
            .navigationTitle("Software License")
            .modifier(NavSubtitleIfAvailable(subtitle: "THIS IS LEGALLY BINDING."))
        }
    }
}

#Preview {
    SoftwareLicenseView()
}
