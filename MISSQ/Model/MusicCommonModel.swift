//
//  MusicCommonModel.swift
//  MoodMusic
//
//  Created by Sunfocus on 13/05/19.
//  Copyright © 2019 Sunfocus. All rights reserved.
//

import UIKit
import SwiftyJSON
import MediaPlayer
import AVKit
import AVFoundation
class SpotifyMusic: NSObject {
    var songURI = String()
    var songName = String()
    var songArtist = String()
    var songImage = String()
    var songDuration = Int()
    override init() {
        
    }
    init(data:JSON) {
        self.songURI = data["uri"].stringValue
        self.songName = data["name"].stringValue
        self.songDuration = data["duration_ms"].intValue
        for song in data["artists"].arrayValue{
            self.songArtist += song["name"].stringValue + ","
        }
        if data["artists"].arrayValue.count > 0{
            self.songArtist =  String(self.songArtist.dropLast())
        }
        let arrImage = data["album"]["images"].arrayValue
        if arrImage.count > 0{
            self.songImage = arrImage[0]["url"].stringValue
        }
        
    }
}
class iPhoneMediaLibrarySongs: NSObject {
    var songURL = String()
    var songName = String()
    var songArtist = String()
    var songImage = UIImage()
    var songDuration = Double()
    var songBPM = Int()
    var mediaItem = MPMediaItem()
    override init() {
        
    }
    init(data:MPMediaItem) {
        super.init()
        if  data.title ?? "" == "Woke"{
            print("Woke")
            
           
        }
            self.songURL = data.assetURL?.absoluteString ?? ""
            self.songName = data.title ?? ""
            self.songArtist = data.artist ?? ""
            self.songImage = data.artwork?.image(at: CGSize(width: 400.0, height: 400.0)) ?? #imageLiteral(resourceName: "Sun")
            self.songDuration = data.playbackDuration
            self.songBPM  = data.beatsPerMinute
            self.mediaItem = data
    
    }
   
}
class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
