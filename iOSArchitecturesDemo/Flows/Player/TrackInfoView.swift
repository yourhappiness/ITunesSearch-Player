//
//  TrackInfoView.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 02/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit
import CoreMedia

protocol TrackInfoViewModelProtocol {  // ViewModel
  var albumImage: Observable<UIImage?>  { get }
  var albumName:  Observable<String?>   { get }
  var artistName: Observable<String?>   { get }
  var trackName:  Observable<String?>   { get }
  var duration: Observable<String?>     { get }
  var currentTime: Observable<String?>  { get }
  var progress: Observable<Float?>      { get }
}


class TrackInfoViewModel: TrackInfoViewModelProtocol {
  
  let currentTrack = Player.shared.currentTrack
  let player = Player.shared
  
  var albumImage: Observable<UIImage?> = Observable(value: nil)
  var albumName:  Observable<String?>  = Observable(value: nil)
  var artistName: Observable<String?>  = Observable(value: nil)
  var trackName:  Observable<String?>  = Observable(value: nil)
  var duration: Observable<String?> = Observable(value: nil)
  var currentTime: Observable<String?> = Observable(value: nil)
  var progress: Observable<Float?> = Observable(value: 0.0)
  
  init() {
    self.albumImage.value = currentTrack.value?.albumImage
    self.albumName.value = currentTrack.value?.albumName
    self.artistName.value = currentTrack.value?.artistName
    self.trackName.value = currentTrack.value?.trackName
    self.duration.value = self.getTimeString(from: currentTrack.value?.duration)
    self.currentTime.value = "0:00"

    self.currentTrack.addObserver(anyObject: self) { [weak self] (old: Track?, new: Track?) in
      self?.trackName.value = new?.trackName
      self?.artistName.value = new?.artistName
      self?.albumName.value = new?.albumName
      self?.albumImage.value = new?.albumImage
      self?.duration.value = self?.getTimeString(from: new?.duration)
    }
//    self.player.currentTime.addObserver(anyObject: self) { [weak self] (old: CMTime?, new: CMTime?) in
//      guard let time = new else {return}
//      self?.currentTime.value = self?.getTimeString(from: time)
//      self?.getCurrentProgress(for: time)
//      guard self?.progress.value == 1 else {return}
//      self?.player.trackIsOver()
//    }
  }
  
  func getTimeString(from time: CMTime?) -> String {
    guard let time = time else {return ""}
    let totalSeconds = Int(CMTimeGetSeconds(time))
    let minutes: Int = totalSeconds / 60
    let seconds = totalSeconds % 60
    let currentTime: String = seconds < 10 ? "\(minutes):0\(seconds)" : "\(minutes):\(seconds)"
    return currentTime
  }
  
  func getCurrentProgress(for currentTime: CMTime) {
    guard let totalTime = self.currentTrack.value?.duration else {return}
    let totalSeconds = Float(CMTimeGetSeconds(totalTime))
    let currentSeconds = Float(CMTimeGetSeconds(currentTime))
    let progress: Float = currentSeconds / totalSeconds
    self.progress.value = progress
  }
}

final class TrackInfoView: UIView {
  @IBOutlet weak var albumImageView:  UIImageView!
  @IBOutlet weak var albumNameLabel:  UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var trackNameLabel:  UILabel!
  
  var viewModel: TrackInfoViewModelProtocol? {
    didSet {
      self.viewModel?.albumName.addObserver(anyObject: self, callback: { [weak self] (oldValue: String?, newString: String?) in
        self?.albumNameLabel?.text  = newString
      })
      
      self.viewModel?.trackName.addObserver(anyObject: self, callback: { [weak self] (oldValue: String?, newString: String?) in
        self?.trackNameLabel?.text  = newString
      })
      
      self.viewModel?.artistName.addObserver(anyObject: self, callback: { [weak self] (oldValue: String?, newString: String?) in
        self?.artistNameLabel?.text  = newString
      })
      
      self.viewModel?.albumImage.addObserver(anyObject: self, callback: { [weak self] (oldValue: UIImage?, newImage: UIImage?) in
        self?.albumImageView?.image  = newImage
      })
    }
  }
}
