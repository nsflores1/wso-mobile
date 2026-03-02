//
//  WSOFacTrakCardView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-20.
//

import SwiftUI

struct WSOFacTrakCardView: View {
    @Environment(\.logger) private var logger
    @Environment(\.openURL) private var openURL
    @Environment(AuthManager.self) private var authManager
    @Environment(NotificationManager.self) private var notificationManager

    let department: WSOFacTrakAreasOfStudy

    var body: some View {
        NavigationLink(
            destination: WSOFacTrakAreaView(
                viewModel: WSOFacTrakAreaViewModel(id: department.id),
                name: department.abbreviation,
                id: department.id
            )
        ) {
            // markdown in Text field trick
            Text("\(department.name) - *\(department.abbreviation)*")
        }
    }
}
