//
//  Track.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 02/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit
import AVFoundation


struct Track: Equatable {
  let artistName: String
  let trackName: String
  let albumName: String
  let albumImage: UIImage
  let duration: CMTime
  let url: URL
}

class TrackAdapter {
  
  var artistName: String? = nil
  var trackName: String? = nil
  var albumName: String? = nil
  var albumImage: UIImage? = nil
  var duration: CMTime? = nil
  let url: URL
  
  init(url: URL) {
    self.url = url
    self.getTrackData(from: url)
  }
  
  func getTrack() -> Track? {
    guard let trackName = self.trackName,
      let artistName = self.artistName,
      let albumName = self.albumName,
      let albumImage = self.albumImage,
      let duration = self.duration else {return nil}
    return Track(artistName: artistName,
                 trackName: trackName,
                 albumName: albumName,
                 albumImage: albumImage,
                 duration: duration,
                 url: self.url)
  }
  
  private func getTrackData(from url: URL) {
    let playerItem = AVPlayerItem(url: url)
    let metadataList = playerItem.asset.metadata
    self.duration = playerItem.asset.duration
    for item in metadataList {
      if item.commonKey != nil && item.value != nil {
        if item.commonKey?.rawValue == "title" {
          self.trackName = item.stringValue
        }
        if item.commonKey?.rawValue == "artist" {
          self.artistName = item.stringValue
        }
        if item.commonKey?.rawValue == "albumName" {
          self.albumName = item.stringValue
        }
        
        if item.commonKey?.rawValue == "artwork" {
          if let data = item.dataValue {
            self.albumImage = UIImage(data: data)
          }
        }
      }
    }
  }
}
