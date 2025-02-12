//
//  SoundManager.swift
//  Set
//
//  Created by MacOS on 2/12/25.
//

import Foundation
import AVKit

class SoundManager {
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            // do nothing
        }
    }
    
    func playSelectSound() {
        guard let url = Bundle.main.url(forResource: "select", withExtension: ".mp3") else { return }
        playSound(url: url)
    }
    
    func playDealThreeMoreCardSound() {
        guard let url = Bundle.main.url(forResource: "dealcards", withExtension: ".mp3") else { return }
        playSound(url: url)
    }
    
    func playFailSound() {
        guard let url = Bundle.main.url(forResource: "fail", withExtension: ".mp3") else { return }
        playSound(url: url)
    }
    
    func playSuccessSound() {
        guard let url = Bundle.main.url(forResource: "success", withExtension: ".mp3") else { return }
        playSound(url: url)
    }
}
