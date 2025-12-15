//
//  MapPageView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-12-15.
//

import SwiftUI
import WebKit

@available(iOS 26.0, *)
struct MapPageView: View {
    @State private var page = WebPage()

    var body: some View {
        VStack {
            Spacer()
            WebView(page)
                .onAppear {
                    page.load(URLRequest(url: URL(string: "https://map.williams.edu")!))
                }
        }
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        MapPageView()
    } else {
            // Fallback on earlier versions
    }
}
