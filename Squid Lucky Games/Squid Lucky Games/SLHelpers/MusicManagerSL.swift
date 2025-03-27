//
//  MusicManagerIE.swift
//  Squid Lucky Games
//
//  Created by Dias Atudinov on 27.03.2025.
//


import AVFoundation

class MusicManagerIE {
    static let shared = MusicManagerIE()
    var audioPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "musicIE", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 
            audioPlayer?.play()
        } catch {
            print("Could not play background music: \(error)")
        }
    }

    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}