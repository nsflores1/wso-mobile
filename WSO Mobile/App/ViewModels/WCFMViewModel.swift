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
    private var metadataTimer: Timer?
    @Published var isPlaying = false
    @Published var streamURL = URL(string: "")
    @Published var currentTrack: WCFMSpinItem?

    init() {
        setupAudioSession()
        setupRemoteControls()
    }

    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
        startMetadataPolling()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        metadataTimer?.invalidate()
        metadataTimer = nil
    }

    private func startMetadataPolling() {
        // poll instantly!
        Task { await updateMetadata() }

        // then do it again every 10 seconds (reasonable amount of time)
        metadataTimer = Timer
            .scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
                Task { await self?.updateMetadata() }
        }
    }

    private func updateMetadata() async {
        guard let info = try? await getWCFMSpin() else {
            currentTrack = nil
            return
        }

        // do it the dumb way, see if it works
        currentTrack = info.items[0]
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
