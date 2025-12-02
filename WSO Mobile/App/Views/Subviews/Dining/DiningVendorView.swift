//
//  DiningVendorView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-20.
//

import SwiftUI
import Foundation
import Combine

struct DiningVendorView: View {
    let menu: [String: Vendor]
    @State private var isExpanded: Set<String> = []

    var body: some View {
        let sortedVendors = menu.keys.sorted()
        ForEach(sortedVendors, id: \.self) { hall in
            if let v = menu[hall] {
                Section(isExpanded: Binding<Bool> (
                    get: {
                        return isExpanded.contains(hall)
                    },
                    set: { isExpanding in
                        if isExpanding {
                            isExpanded.insert(hall)
                        } else {
                            isExpanded.remove(hall)
                        }
                    }
                ), content: {
                    if v.meals.isEmpty {
                        Text("(No meals today)")
                            .italic(true)
                    } else {
                        DiningMealView(meals: v.meals)
                    }
                },
                header: {
                    Text(v.name)
                        .fontWeight(.semibold)
                        .font(.title3)
                })
            }
        }
    }
}

#Preview {
    DiningView()
}
