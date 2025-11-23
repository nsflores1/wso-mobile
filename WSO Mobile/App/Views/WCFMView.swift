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
        NavigationStack {
            VStack {
                if player.isPlaying, let track = player.currentTrack {
                    AsyncImage(url: track.image) { picture in
                        picture
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text(track.song)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("\(track.artist) - \(track.release)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    // this trick means NO changes on the year value
                    Text(verbatim: "Released in: \(track.released)")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Text("Track started at: \(track.start.formatted())")

                    Spacer()
                    Text("TODO: put show info here")
                    // TODO: it would be awesome to have a list of past tracks
                    // also, show info would be huge

                    Button {
                        player.pause()
                    } label : {
                        Label("Pause", systemImage: "pause")
                    }
                    .padding(10)
                    .buttonStyle(.borderedProminent)
                    .controlSize(ControlSize.large)
                }
                else {
                    Label("Radio not current playing...",
                          systemImage: "antenna.radiowaves.left.and.right")
                        .font(.title)
                        .italic(true)

                    Button {
                        player.play(url: streamURL!)
                    } label : {
                        Label("Play", systemImage: "play")
                    }
                    .padding(10)
                    .buttonStyle(.borderedProminent)
                    .controlSize(ControlSize.large)
                }
            }
            .navigationTitle(Text("WCFM Radio"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WCFMView().environmentObject(AppSettings.shared)
}
