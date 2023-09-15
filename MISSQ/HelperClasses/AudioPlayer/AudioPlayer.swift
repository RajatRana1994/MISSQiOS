//
//  AudioPlayer.swift
//  CollerBook
//
//  Created by iOS on 10/09/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import AudioToolbox

protocol AudioPlayerDelegate{
    func updateProgress(progress:TimeInterval)
    func audioPlayerDidFinishCalled(duration:TimeInterval)
}
class AudioPlayer:NSObject{
    
    //MARK: Variables
    static let shared = AudioPlayer()
    var musicDelegate : AudioPlayerDelegate? = nil
    var updateTimer: Timer?
    var audioPlayer : AVAudioPlayer?
    
    public var playing = false {
        didSet {
            if playing {
                audioPlayer?.play()
            } else {
                audioPlayer?.pause()
            }
        }
    }

    //MARK: Player Custom Methods
    func playAudio(songUrl:URL) {
        do {
            //Notification
            let data = try Data(contentsOf: songUrl)
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer!.prepareToPlay()
            audioPlayer!.numberOfLoops = 0
            audioPlayer!.delegate = self
            audioPlayer!.play()
            startTimer()
            
        } catch {
            print("Cannot play the file URl")
        }
    }
    //Update Progress
    @objc func updateTime(_ timer: Timer) {
        print("audio player current time \(audioPlayer!.currentTime) ")
        self.musicDelegate?.updateProgress(progress: audioPlayer?.currentTime ?? 0.0)
    }
    //MARK: Play and Pause
    func stop(){
        if audioPlayer != nil {
            if audioPlayer?.isPlaying == true{
                invalidateTimer()
                audioPlayer?.stop()
            }
        }
       
    }
    func play() {
        if audioPlayer != nil {
            if audioPlayer?.isPlaying == false  {
                startTimer()
                audioPlayer?.play()
            }
        }
    }
    func invalidateTimer(){
        updateTimer?.invalidate()
    }
    func startTimer(){
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(timeInterval: 1.0/60.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
    }
}


//MARK: AVAudioPlayerDelegate
extension AudioPlayer: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.pause()
        self.invalidateTimer()
        self.musicDelegate?.audioPlayerDidFinishCalled(duration: player.duration)
        
    }
}

