//
//  DiningMealView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation
import Combine

struct DiningMealView: View {
    let meals: [String: Meals]

    var body: some View {
        let sortedMeals = meals.keys.sorted()
        ForEach(sortedMeals, id: \.self) { meal in
            if let m = meals[meal] {
                Text("\(m.name.capitalized) (\(m.hours.open.replacingOccurrences(of: ":00", with: ""))-\(m.hours.close.replacingOccurrences(of: ":00", with: "")))")
                    .bold(true)
                    .foregroundStyle(ColorScheme.dark.self == .dark ? Color.white : Color.black)
                    .listRowBackground(Color.accent)
                Section {
                    DiningCoursesView(courses: m.courses ?? [:])
                }
            }
        }
    }
}

#Preview {
    DiningView()
}
