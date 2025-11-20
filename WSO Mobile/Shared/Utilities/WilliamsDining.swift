//
//  WilliamsDining.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-19.
//

// dining is LITERALLY the devil.
// if this breaks, you're on your own. sorry.
// we parse the WSO backend, that needs to be kept stable,
// since it's easier to patch backend than the app.

import SwiftUI
import Combine
import Foundation

struct MenuResponse: Codable {
    let vendors: [String: Vendor]
}

struct Vendor: Codable {
    let name: String
    let meals: [String: Meals]
    let onlineOrder: Bool
    let operating: Bool
}

struct Meals: Codable {
    let name: String
    let hours: Hours
    let courses: [String: Course]?
}

struct Hours: Codable {
    let open: String
    let close: String
}

struct Course: Codable {
    let name: String
    let items: [MenuItem]
}

struct MenuItem: Codable {
    let name: String
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
}

struct WilliamsDiningParseError : Error {}

func parseWilliamsDining() async throws -> MenuResponse {
    let url = URL(string: "https://wso.williams.edu/dining.json")!
    do {
        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try JSONDecoder().decode(MenuResponse.self, from: data)

        return response
    } catch {
        throw WilliamsDiningParseError()
    }
}

func doWilliamsDining() async {
    do {
        let response = try await parseWilliamsDining()

        for (_, vendor) in response.vendors {
            print("vendor: \(vendor.name)")

            for (_, meal) in vendor.meals {
                print("  meal: \(meal.name) (\(meal.hours.open) - \(meal.hours.close))")

                if let courses = meal.courses {
                    for (_, course) in courses {
                        print("    course: \(course.name)")
                        for item in course.items {
                            print("      - \(item.name)")
                        }
                    }
                }
            }
        }
    } catch {
        print("No menu contents")
    }
}
