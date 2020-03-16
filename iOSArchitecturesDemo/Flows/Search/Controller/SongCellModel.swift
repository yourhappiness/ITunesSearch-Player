//
//  SongCellModel.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 27/10/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

struct SongCellModel { //Entity
  let trackName: String
  let artistName: String?
  let collectionName: String?
  let songImageUrl: String?
}

final class SongCellModelFactory {
  
  static func cellModel(from model: ITunesSong) -> SongCellModel {
    return SongCellModel(trackName: model.trackName,
                        artistName: model.artistName,
                        collectionName: model.collectionName,
                        songImageUrl: model.artwork)
  }
}
