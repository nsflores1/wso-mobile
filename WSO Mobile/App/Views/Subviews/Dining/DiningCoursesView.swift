//
//  DiningCoursesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation

struct DiningCoursesView: View {
    let courses: [Courses]
    let name: String
    let time: String

    var body: some View {
        NavigationStack {
            List {
                if courses.isEmpty {
                    Text("(No meals at this time)").italic()
                } else {
                    // no nav subtitle so need different way to do this
                    if #unavailable(iOS 26) {
                        Text(time)
                    }
                    ForEach (courses.sorted(), id: \.courseTitle) { course in
                        Text(course.courseTitle)
                            .bold(true)
                            .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                            .listRowBackground(Color.accent)
                        DiningItemsView(items: course.foodItems)
                    }
                }
            }.navigationTitle(name)
            .navSubtitleIfAvailable(time)
        }
    }
}

#Preview {
    DiningView()
}
