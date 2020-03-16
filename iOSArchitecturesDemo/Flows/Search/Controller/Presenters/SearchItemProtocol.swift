//
//  SearchItemProtocol.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 05/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchItemProtocol {
  
  static func registerCell(in tableView: UITableView)
  
  func didSelect(in viewController: UIViewController)
  
  func getCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
  
}


class SearchItemAppAdapter: SearchItemProtocol { //Presenter
  
  private let app: ITunesApp
  private let router: SearchRouterProtocol?
  
  init(app: ITunesApp, router: SearchRouterProtocol?) {
    self.app = app
    self.router = router
  }
  
  static func registerCell(in tableView: UITableView) {
    tableView.register(AppCell.self, forCellReuseIdentifier: "AppCell")
  }
  
  func didSelect(in viewController: UIViewController) {
    self.router?.openDetails(for: self.app, in: viewController)
  }
  
  func getCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "AppCell", for: indexPath)
    guard let cell = dequeuedCell as? AppCell else {
      return dequeuedCell
    }
    let app = self.app
    let cellModel = AppCellModelFactory.cellModel(from: app)
    cell.configure(with: cellModel)
    return cell
  }
}

class SearchItemSongAdapter: SearchItemProtocol { //Presenter
  
  private let song: ITunesSong
  private let imageDownloader = ImageDownloader()
  private let router: SearchRouterProtocol?
  
  init(song: ITunesSong, router: SearchRouterProtocol?) {
    self.song = song
    self.router = router
  }
  
  static func registerCell(in tableView: UITableView) {
    tableView.register(SongCell.self, forCellReuseIdentifier: "SongCell")
  }
  
  func didSelect(in viewController: UIViewController) {
  }
  
  func getCell(in tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
    guard let cell = dequeuedCell as? SongCell else {
      return dequeuedCell
    }
    let song = self.song
    let cellModel = SongCellModelFactory.cellModel(from: song)
    cell.configure(with: cellModel)
    if let url = cellModel.songImageUrl {
      self.downloadImage(from: url, for: cell)
    }
    return cell
  }
  
  private func downloadImage(from url: String, for cell: SongCell) {
    cell.throbber.startAnimating()
    self.imageDownloader.getImage(fromUrl: url) { (image, error) in
      cell.throbber.stopAnimating()
      guard let image = image else { return }
      cell.songImageView.image = image
    }
  }
}

