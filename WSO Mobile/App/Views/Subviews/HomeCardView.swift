//
//  HomeCardView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

import SwiftUI
import Kingfisher

struct HomeCardView: View {
    let user: User

    var body: some View {
        NavigationLink(destination: WSOProfileView(viewModel: WSOUserViewModel(userID: user.id))) {
            VStack() {
                Text(user.name)
                Text(user.unixID).italic()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AuthManager.shared)
        .environment(NotificationManager.shared)
}
