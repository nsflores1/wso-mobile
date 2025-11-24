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
                    .transition(.scale.combined(with: .opacity))

                    Text(track.song)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    Text("\(track.artist) - \(track.release)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    // this trick means NO changes on the year value
                    Text(verbatim: "Released in: \(track.released)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    Text("Track started at: \(track.start.formatted())")
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                    Spacer()
                    Text("TODO: put show info here")
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                else {
                    Label("Radio not current playing...",
                          systemImage: "antenna.radiowaves.left.and.right")
                        .font(.title)
                        .italic(true)
                        .transition(.scale.combined(with: .opacity))

                    Button {
                        player.play(url: streamURL!)
                    } label : {
                        Label("Play", systemImage: "play")
                    }
                    .padding(10)
                    .buttonStyle(.borderedProminent)
                    .controlSize(ControlSize.large)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: player.isPlaying)
            .animation(.easeInOut, value: player.currentTrack?.id)
            .navigationTitle(Text("WCFM Radio"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WCFMView().environmentObject(AppSettings.shared)
}
