//
//  WCFMView.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-18.
//

import SwiftUI
import Combine
import Foundation
import AVFoundation

// TODO: add metadata

struct WCFMView: View {
    @StateObject private var player = WCFMViewModel()
    let streamURL = URL(string: "http://wcfm-streaming.williams.edu:8000/stream")

    var body: some View {
        VStack {
            Text("WCFM live radio")

            Button(player.isPlaying ? "pause" : "play") {
                if player.isPlaying {
                    player.pause()
                } else {
                    player.play(url: streamURL!)
                }
            }
        }
    }
}

#Preview {
    WCFMView().environmentObject(AppSettings.shared)
}
