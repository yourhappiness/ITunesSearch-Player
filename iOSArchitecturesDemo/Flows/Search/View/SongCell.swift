//
//  SongCell.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 27/10/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

  // MARK: - Subviews
  
  let songImageView = UIImageView()
  let throbber = UIActivityIndicatorView(style: .gray)
  
  private(set) lazy var trackNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 16.0)
    return label
  }()
  
  private(set) lazy var artistNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 13.0)
    return label
  }()
  
  private(set) lazy var collectionNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 12.0)
    return label
  }()
  
  // MARK: - Init
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.configureUI()
  }
  
  // MARK: - Methods
  
  func configure(with cellModel: SongCellModel) {
    self.trackNameLabel.text = cellModel.trackName
    self.artistNameLabel.text = cellModel.artistName
    self.collectionNameLabel.text = cellModel.collectionName
  }
  
  // MARK: - UI
  
  override func prepareForReuse() {
    [self.trackNameLabel, self.artistNameLabel, self.collectionNameLabel].forEach { $0.text = nil }
    self.imageView?.image = nil
  }
  
  private func configureUI() {
    self.addImageView()
    self.addImageViewThrobber()
    self.addTrackNameLabel()
    self.addArtistNameLabel()
    self.addCollectionNameLabel()
  }
  
  private func addTrackNameLabel() {
    self.contentView.addSubview(self.trackNameLabel)
    NSLayoutConstraint.activate([
      self.trackNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
      self.trackNameLabel.leftAnchor.constraint(equalTo: self.songImageView.rightAnchor, constant: 12.0),
      self.trackNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
      ])
  }
  
  private func addArtistNameLabel() {
    self.contentView.addSubview(self.artistNameLabel)
    NSLayoutConstraint.activate([
      self.artistNameLabel.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 4.0),
      self.artistNameLabel.leftAnchor.constraint(equalTo: self.songImageView.rightAnchor, constant: 12.0),
      self.artistNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
      ])
  }
  
  private func addCollectionNameLabel() {
    self.contentView.addSubview(self.collectionNameLabel)
    NSLayoutConstraint.activate([
      self.collectionNameLabel.topAnchor.constraint(equalTo: self.artistNameLabel.bottomAnchor, constant: 4.0),
      self.collectionNameLabel.leftAnchor.constraint(equalTo: self.songImageView.rightAnchor, constant: 12.0),
      self.collectionNameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40.0)
      ])
  }
  
  private func addImageView() {
    self.songImageView.translatesAutoresizingMaskIntoConstraints = false
    self.songImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    self.songImageView.layer.cornerRadius = 10.0
    self.songImageView.layer.masksToBounds = true
    self.contentView.addSubview(self.songImageView)
    NSLayoutConstraint.activate([
      self.songImageView.widthAnchor.constraint(equalTo: self.songImageView.heightAnchor),
      self.songImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
      self.songImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12.0),
      self.songImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0)
      ])
  }
  
  private func addImageViewThrobber() {
    self.throbber.translatesAutoresizingMaskIntoConstraints = false
    self.songImageView.addSubview(self.throbber)
    NSLayoutConstraint.activate([
      self.throbber.centerXAnchor.constraint(equalTo: self.songImageView.centerXAnchor),
      self.throbber.centerYAnchor.constraint(equalTo: self.songImageView.centerYAnchor)
      ])
  }

}
