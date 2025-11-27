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

    var body: some View {
        let sortedVendors = menu.keys.sorted()
        ForEach(sortedVendors, id: \.self) { hall in
            if let v = menu[hall] {
                Section {
                    if v.meals.isEmpty {
                        Text("(No meals today)")
                            .italic(true)
                    } else {
                        DiningMealView(meals: v.meals)
                    }
                } header : {
                    Text(v.name)
                        .fontWeight(.semibold)
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    DiningView()
}
