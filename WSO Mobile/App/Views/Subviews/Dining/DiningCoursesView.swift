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

    var body: some View {
        if courses.isEmpty {
            Text("(No meals at this time)")
        } else {
            ForEach (courses.sorted(), id: \.courseTitle) { course in
                Text(course.courseTitle)
                    .bold(true)
                    .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                    .listRowBackground(Color.accent)
                DiningItemsView(items: course.foodItems)
            }
        }
    }
}

#Preview {
    DiningView()
}
