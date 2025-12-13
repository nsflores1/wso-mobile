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
    @Published var error: Error?
    @Published var streamURL = URL(string: "")
    @Published var currentTrack: WCFMSpinItem?

    init(url: URL) {
        player = AVPlayer(url: url)
        setupAudioSession()
        setupRemoteControls()
    }

    func play() {
        // recover if we were murdered
        if player?.currentItem?.status == .failed {
            let item = AVPlayerItem(url: streamURL!)
            player?.replaceCurrentItem(with: item)
        }

        // reactivate if we were deactivated
        try? AVAudioSession.sharedInstance().setActive(true)

        player?.play()
        // TODO: we should check to see if the URL is accessible to us rather than
        // failing silently. big source of user confusion.
        // we also need to check if there's silence, and then pass some other
        // state rather than just isPlaying to un-gate the view
        isPlaying = true

        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = "WCFM Live Radio"
        info[MPMediaItemPropertyArtist] = "Loading..."
        info[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info

        startMetadataPolling()
    }

    func pause() {
        // TODO: the in-app pause should also kill the player,
        // it needs to be a separate function.
        // we need to detach from the MPNowPlayingCenter.

        // also, pausing outside of the app crashes the player?
        
        player?.pause()
        isPlaying = false
        //player?.replaceCurrentItem(with: nil)
        metadataTimer?.invalidate()
        metadataTimer = nil

        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = "WCFM Live Radio"
        info[MPMediaItemPropertyArtist] = "(Paused)"
        info[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func startMetadataPolling() {
        // poll instantly!
        Task {
            await updateMetadata()
        }

        // then do it again every 10 seconds (reasonable amount of time)
        scheduleNextPoll()
    }

    private func scheduleNextPoll() {
        metadataTimer?.invalidate()

        if let endTime = currentTrack?.end {
            let timeUntilEnd = endTime.timeIntervalSinceNow

            if timeUntilEnd > 0 {
                metadataTimer = Timer.scheduledTimer(withTimeInterval: timeUntilEnd + 5, repeats: false) { [weak self] _ in
                    Task {
                        await self?.updateMetadata()
                        await self?.scheduleNextPoll()
                    }
                }
            } else {
                Task {
                    await updateMetadata()
                }
            }
        } else {
            metadataTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                Task {
                    await self?.updateMetadata()
                }
            }
        }
    }

    private func updateMetadata() async {
        guard let info = try? await getWCFMSpin() else {
            currentTrack = nil
            return
        }

        // do it the dumb way, see if it works
        currentTrack = info.items[0]
        updateNowPlaying()
    }

    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default)
        try? session.setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func setupRemoteControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            if self?.isPlaying == true {
                self?.pause()
            } else {
                self?.play()
            }
            return .success
        }
    }

    // TODO: figure out if this extra annotation is nonsense paranoia or not
    @MainActor
    private func updateNowPlaying() {
        var info = [String: Any]()
        if let currentTrack {
            info[MPMediaItemPropertyTitle] = currentTrack.song
            info[MPMediaItemPropertyArtist] = currentTrack.artist
            info[MPMediaItemPropertyGenre] = "Radio"

            info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
            // we're a radio stream, so no time ever passes
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0

            // set it now just in case we can't find an image
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info

            if currentTrack.image != nil {
                Task {
                    if let imageData = try? await URLSession.shared.data(from: currentTrack.image!).0,
                       let image = UIImage(data: imageData) {
                        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(
                            boundsSize: image.size
                        ) { _ in image }
                    }

                    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                }
            }
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        }
    }

}
