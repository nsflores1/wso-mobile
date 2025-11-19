//
//  WCFMViewModel.swift
//  WSO Mobile
//
//  Created by Nathaniel Flores on 2025-11-18.
//

import SwiftUI
import Combine
import AVFoundation
import MediaPlayer

// this is one of the few ones with no base CLI class,
// because it's completely GUI-mode. can't hear audio on the CLI!

@MainActor
class WCFMViewModel: ObservableObject {
    private var player: AVPlayer?
    @Published var isPlaying = false
    @Published var streamURL = URL(string: "")

    init() {
        setupAudioSession()
        setupRemoteControls()
    }

    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
    }

    private func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play(url: self?.streamURL ?? URL(string: "")!)
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
    }

    private func updateNowPlaying() {
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = "WCFM Radio"
        info[MPMediaItemPropertyArtist] = "Williams College"

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

}
