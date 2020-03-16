//
//  Player.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 02/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation
import AVFoundation

class Player {
  
  private var tracks: [Track] = []
  private var playerInstance: AVPlayer?
  
  private init() {
    self.setTracks()
    self.currentTrack = Observable(value: self.tracks[0])
    guard let url = self.currentTrack.value?.url else {return}
    self.playerInstance = AVPlayer(url: url)
    self.playerInstance?.addPeriodicTimeObserver(
      forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
      queue: DispatchQueue.main) { time in
      self.currentTime.value = time
    }
    
    self.currentTrack.addObserver(anyObject: self) { [weak self] (old: Track?, new: Track?) in
      guard let url = new?.url else {return}
      self?.playerInstance = AVPlayer(url: url)
      self?.playerInstance?.addPeriodicTimeObserver(
        forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
        queue: DispatchQueue.main) { time in
          self?.currentTime.value = time
      }
    }
    self.shuffleIsOn.addObserver(anyObject: self) { [weak self] (old: Bool, new: Bool) in
      if new {
        self?.tracks.shuffle()
      } else {
        self?.tracks = []
        self?.setTracks()
      }
    }
    self.currentTime.addObserver(anyObject: self) { [weak self] (old: CMTime?, new: CMTime?) in
      guard let time = new else {return}
      let progress = self?.getCurrentProgress(for: time)
      guard progress == 1 else {return}
      self?.trackIsOver()
    }
    
  }
  
  static let shared = Player()
  
  var currentTrack: Observable<Track?> = Observable(value: nil)
  var shuffleIsOn: Observable<Bool> = Observable(value: false)
  var repeatIsOn: Observable<Bool> = Observable(value: false)
  var isPlaying: Observable<Bool> = Observable(value: false)
  var currentTime: Observable<CMTime?> = Observable(value: CMTime(
    seconds: 0,
    preferredTimescale: 1))
  
  private func setTracks() {
    guard let path1 = Bundle.main.path(forResource: "Hymn for the Weekend", ofType: "m4a"),
      let path2 = Bundle.main.path(forResource: "Adventure of a Lifetime", ofType: "m4a"),
      let path3 = Bundle.main.path(forResource: "I Love You So", ofType: "m4a") else {return}
    let trackUrl1 = URL(fileURLWithPath: path1)
    let trackUrl2 = URL(fileURLWithPath: path2)
    let trackUrl3 = URL(fileURLWithPath: path3)
    guard let track1 = TrackAdapter(url: trackUrl1).getTrack(),
      let track2 = TrackAdapter(url: trackUrl2).getTrack(),
      let track3 = TrackAdapter(url: trackUrl3).getTrack() else {return}
    self.tracks.append(contentsOf: [track1, track2, track3])
  }
  
  func getCurrentProgress(for currentTime: CMTime) -> Float {
    guard let totalTime = self.currentTrack.value?.duration else {return 0.0}
    let totalSeconds = Float(CMTimeGetSeconds(totalTime))
    let currentSeconds = Float(CMTimeGetSeconds(currentTime))
    let progress: Float = currentSeconds / totalSeconds
    return progress
  }
  
  func next() {
    if self.shuffleIsOn.value {
      self.tracks.shuffle()
    }
    guard let currentTrack = self.currentTrack.value else {return}
    var currentIndex: Int? = self.tracks.firstIndex(where: { $0 == currentTrack})
    if currentIndex == nil {
      currentIndex = -1
    }
    var nextIndex = currentIndex! + 1
    if nextIndex == self.tracks.count {
      nextIndex = 0
    }
    self.currentTrack.value = self.tracks[nextIndex]
    self.currentTime.value = CMTime(seconds: 0, preferredTimescale: 1)
  }
  
  func play() {
    guard let player = self.playerInstance else {return}
    player.play()
    self.isPlaying.value = true
  }
  
  func pause() {
    guard let player = self.playerInstance, self.isPlaying.value else {return}
    player.pause()
    self.isPlaying.value = false
  }
  
  func previous() {
    if self.shuffleIsOn.value {
      self.tracks.shuffle()
    }
    guard let currentTrack = self.currentTrack.value else {return}
    var currentIndex: Int? = self.tracks.firstIndex(where: { $0 == currentTrack})
    if currentIndex == nil {
      currentIndex = self.tracks.count
    }
    var nextIndex = currentIndex! - 1
    if nextIndex == -1 {
      nextIndex = self.tracks.count - 1
    }
    self.currentTrack.value = self.tracks[nextIndex]
    self.currentTime.value = CMTime(seconds: 0, preferredTimescale: 1)
  }
  
  func shuffle() {
    self.shuffleIsOn.value = !self.shuffleIsOn.value
  }
  
  func repeatTrack() {
    self.repeatIsOn.value = !self.repeatIsOn.value
  }
  
  func trackIsOver() {
    guard self.repeatIsOn.value else {
      self.next()
      self.play()
      return
    }
    self.currentTime.value = CMTime(seconds: 0, preferredTimescale: 1)
    self.playerInstance?.seek(to: CMTime(value: 0, timescale: 1))
    self.play()
  }
}
