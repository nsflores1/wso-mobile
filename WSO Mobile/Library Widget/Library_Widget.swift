//
//  Library_Widget.swift
//  Library Widget
//
//  Created by Nathaniel Flores on 2026-01-19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), libraries: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: Date(), libraries: loadLibraries()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: Date(), libraries: loadLibraries())
        let next = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func loadLibraries() -> [LibraryViewData] {
        guard let shared = UserDefaults(suiteName: "group.com.WSO"),
              let data = shared.data(forKey: "libraries"),
              let libraries = try? JSONDecoder().decode([LibraryViewData].self, from: data) else {
            return []
        }
        return libraries
    }
}

struct Entry: TimelineEntry {
    let date: Date
    let libraries: [LibraryViewData]
}

struct WidgetView: View {
    var entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if entry.libraries.isEmpty {
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(Color(.secondaryLabel))
            } else {
                    ForEach(entry.libraries) { place in
                        VStack(alignment: .leading) {
                            Text("\(place.name):")
                                .font(.system(size: 13))
                            HStack {
                                HStack {
                                        // only render hours if there's anything to show in the first place
                                    if !place.open.isEmpty && !place.close.isEmpty {
                                        if !place.open.isEmpty {
                                            Text(place.open.joined(separator: ", "))
                                                .foregroundStyle(.secondary)
                                                .font(.system(size: 13))
                                        } else {
                                            Text("N/A")
                                                .foregroundStyle(.secondary)
                                                .font(.system(size: 13))
                                        }
                                        Text("-").foregroundStyle(.secondary)
                                            .font(.system(size: 13))
                                        if !place.close.isEmpty {
                                            Text(place.close.joined(separator: ", "))
                                                .foregroundStyle(.secondary)
                                                .font(.system(size: 13))
                                        } else {
                                            Text("N/A")
                                                .foregroundStyle(.secondary)
                                                .font(.system(size: 13))
                                        }
                                    } else {
                                        Text("(No hours today)")
                                            .foregroundStyle(.secondary)
                                            .font(.system(size: 13))
                                    }
                                }.padding(.horizontal, 3)
                            }
                        }
                    }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct Library_Widget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "LibraryHours", provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("Library Hours")
        .description("See library hours, like the homepage")
        .supportedFamilies([.systemSmall])
    }
}
