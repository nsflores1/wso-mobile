//
//  LogViewerView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-29.
//

import SwiftUI

struct LogViewerView: View {
    @State private var logContent: String = ""
    @State private var isLoading = true
    @State private var showingClearConfirmation = false

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        Text(logContent)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .textSelection(.enabled)
                    }
                }
            }
            .navigationTitle("Debug Logs")
            .modifier(NavSubtitleIfAvailable(subtitle: "In reverse order"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: copyLog) {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    ShareLink(item: logFileURL()) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .destructive, action: { showingClearConfirmation = true }) {
                        Label("Clear", systemImage: "trash")
                    }
                }
            }
            .confirmationDialog("Clear log file?", isPresented: $showingClearConfirmation) {
                Button("Clear log", role: .destructive) {
                    clearLog()
                }
            }
            .task {
                await loadLog()
            }
        }
    }

    func clearLog() {
        let url = logFileURL()
        try? FileManager.default.removeItem(at: url)
        FileManager.default.createFile(atPath: url.path, contents: nil)
        logContent = ""
    }

    func loadLog() async {
        isLoading = true
        defer { isLoading = false }

        let url = logFileURL()
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            logContent = "no log file found"
            return
        }

        logContent = content.components(separatedBy: "\n")
            .reversed()
            .joined(separator: "\n")
    }

    func copyLog() {
        UIPasteboard.general.string = logContent
    }

    func logFileURL() -> URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("app.log")
    }
}
