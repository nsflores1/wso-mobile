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
import Marquee
import Kingfisher

// TODO: add metadata

struct WCFMView: View {
    @StateObject private var player = WCFMViewModel(url: URL(string: "http://wcfm-streaming.williams.edu:8000/stream")!)

    // haptic feedback
    let impact = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        NavigationStack {
            VStack {
                if player.isPlaying, let track = player.currentTrack {
                    KFImage(track.image)
                        .placeholder { ProgressView() }
                        .fade(duration: 0.25)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .transition(.scale.combined(with: .opacity))
                    // TODO: find a long song title, add marquee
                    Text(track.song)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(5)
                    Text("\(track.artist ?? "Anonymous") - \(track.release ?? "(unknown)")")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        // this trick converts an int to a flat number
                        // such a mess. spinitron is the devil
                    Text(verbatim: "\(track.label ?? "(No label)"), \(track.released, default: "(No release date)")")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    Text("Track started at: \(track.start.formatted())")
                        .transition(.move(edge: .bottom).combined(with: .opacity))

                    HStack {
                        NavigationLink(destination: WCFMShowsView()) {
                            Label("Shows", systemImage: "music.microphone")
                        }
                        .padding(10)
                        .buttonStyle(.borderedProminent)
                        .controlSize(ControlSize.large)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        NavigationLink(destination: WCFMPlaylistView()) {
                            Label("Playlists", systemImage: "scroll")
                        }
                        .padding(10)
                        .buttonStyle(.borderedProminent)
                        .controlSize(ControlSize.large)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }

                    Spacer()
                        // TODO: it would be awesome to have a list of past tracks
                        // also, show info would be huge

                    Button {
                        impact.impactOccurred()
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
                    Label("Player is inactive...",
                          systemImage: "antenna.radiowaves.left.and.right")
                    .font(.title)
                    .italic(true)
                    .transition(.scale.combined(with: .opacity))

                    Button {
                        impact.impactOccurred()
                        player.play()
                    } label : {
                        Label("Play", systemImage: "play")
                    }
                    .padding(10)
                    .buttonStyle(.borderedProminent)
                    .controlSize(ControlSize.large)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        NavigationLink(destination: WCFMKeyView()) {
                            Image(systemName: "questionmark")
                        }
                    }
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: player.isPlaying)
            .animation(.easeInOut, value: player.currentTrack?.id)
            .navigationTitle(Text("WCFM Radio"))
            .modifier(NavSubtitleIfAvailable(subtitle: "This only works if the station is active"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    WCFMView()
}
