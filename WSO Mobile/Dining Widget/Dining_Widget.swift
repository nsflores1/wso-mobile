//
//  Dining_Widget.swift
//  Dining Widget
//
//  Created by Nathaniel Flores on 2026-01-19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), halls: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: Date(), halls: loadHalls()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: Date(), halls: loadHalls())
        let next = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

//    private func loadHalls() -> [DiningHall] {
//        guard let shared = UserDefaults(suiteName: "group.com.WSO"),
//              let data = shared.data(forKey: "halls"),
//              let halls = try? JSONDecoder().decode([DiningHall].self, from: data) else {
//            return []
//        }
//        return halls
//    }

    private func loadHalls() -> [DiningHall] {
        print("Widget: attempting to load halls")

        guard let shared = UserDefaults(suiteName: "group.com.WSO") else {
            print("Widget: failed to open app group")
            return []
        }

        guard let data = shared.data(forKey: "halls") else {
            print("Widget: no data found in app group")
            return []
        }

        guard let halls = try? JSONDecoder().decode([DiningHall].self, from: data) else {
            print("Widget: failed to decode data")
            return []
        }

        print("Widget: successfully loaded \(halls.count) halls")
        return halls
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let halls: [DiningHall]
}

struct WidgetView: View {
    var entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if entry.halls.isEmpty {
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))

            } else {
                ForEach(entry.halls.sorted(), id: \.hallName) { hall in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(hall.isOpenNow(now: normalizedNowMinutes()) ? .green : .red)
                            .frame(width: 8, height: 8)
                        Text(hall.hallName)
                            .font(.system(size: 13))
                    }

                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct Dining_Widget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "DiningWidget", provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("Dining Halls")
        .description("See which dining halls are currently open")
        .supportedFamilies([.systemSmall])
    }
}
