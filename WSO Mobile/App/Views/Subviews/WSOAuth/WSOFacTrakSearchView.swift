//
//  WSOFacTrakSearchView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2026-02-07.
//

// this view is for the cards that you see in the search.

import SwiftUI

struct WSOFacTrakSearchView: View {
    let item: WSOFacTrakSearch

    var body: some View {
        if item.type == "professor" {
            NavigationLink(
                destination: WSOFacTrakProfView(
                    userViewModel: WSOUserViewModel(userID: item.id),
                    reviewsViewModel: WSOFacTrakReviewsViewModel(id: item.id, type: .Professor),
                    viewModel: WSOFacTrakProfViewModel(id: item.id),
                    id: item.id
                )
            ) {
                Image(systemName: "person")
                Text(item.value)
                Spacer()
            }
        } else if item.type == "area" {
            HStack {
                Image(systemName: "graduationcap")
                Text(item.value)
            }
        } else if item.type == "course" {
            NavigationLink(
                destination: WSOFacTrakCourseView(
                    viewModel: WSOFacTrakReviewsViewModel(id: item.id, type: .Course),
                    name: item.value,
                    id: item.id
                )
            ) {
                Image(systemName: "studentdesk")
                Text(item.value)
                Spacer()
            }
        }
    }
}
