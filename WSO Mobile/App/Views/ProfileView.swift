//
//  ProfileView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var settings: AppSettings
    var body: some View {
        NavigationStack {
            List {
                Toggle("Mathematical Mode", isOn: $settings.likesMath)
                // TODO: test if this works on device
                    .sensoryFeedback(.selection, trigger: settings.likesMath)
                Text("another setting")
            }
            .navigationTitle(Text("Settings"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppSettings.shared)
}
