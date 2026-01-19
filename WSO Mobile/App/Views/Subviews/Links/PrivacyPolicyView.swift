//
//  PrivacyPolicyView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-01-18.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        NavigationStack {
            PrivacyPolicyTextView()
            .navigationTitle("Privacy Policy")
            .modifier(NavSubtitleIfAvailable(subtitle: "THIS IS LEGALLY BINDING."))
        }
    }
}

#Preview {
    PrivacyPolicyView()
}

