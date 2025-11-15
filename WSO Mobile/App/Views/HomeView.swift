//
//  HomeView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-09.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Williams Students Online")
                .font(Font.system(size: 30))
            Text("For students, by students!")
                .italic(true)
            Divider()
        }
    }
}

#Preview {
    HomeView().environmentObject(AppSettings.shared)
}
