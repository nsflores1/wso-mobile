//
//  DiningCoursesView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation
import Combine

struct DiningCoursesView: View {
    let courses: [String: Course]

    var body: some View {
        let sortedCourses = courses.keys.sorted()
        ForEach(sortedCourses, id: \.self) { course in
            if let c = courses[course] {
                Text(c.name)
                    .italic(true)
                    .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                    .listRowBackground(Color.gray)
                DiningItemsView(items: c.items)
            }
        }
    }
}

#Preview {
    DiningView()
}
