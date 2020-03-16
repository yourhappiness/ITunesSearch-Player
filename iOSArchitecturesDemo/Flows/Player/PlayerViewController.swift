//
//  PlayerViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Ivanov on 30.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

final class PlayerViewController: UIViewController {
    
    // Current info
    @IBOutlet weak var trackInfoView: TrackInfoView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var nextTrackButton: UIButton!
    @IBOutlet weak var prevTrackButton: UIButton!
    
    @IBOutlet weak var progressView:     UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel:   UILabel!
    
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton:  UIButton!
    
    let player = Player.shared
  
    var viewModel: TrackInfoViewModelProtocol? {
      didSet {
        self.viewModel?.duration.addObserver(anyObject: self, callback: { [weak self] (oldValue: String?, newString: String?) in
          self?.totalTimeLabel.text = newString
        })
        self.viewModel?.currentTime.addObserver(anyObject: self, callback: { [weak self] (oldValue: String?, newString: String?) in
          self?.currentTimeLabel.text = newString
        })
        self.viewModel?.progress.addObserver(anyObject: self, callback: { [weak self] (oldValue: Float?, newValue: Float?) in
          guard let progress = newValue else {return}
          self?.progressView.setProgress(progress, animated: true)
        })
      }
    }
  
    override func viewDidLoad() {
      super.viewDidLoad()
      self.assignViewModel()
      self.setUI()
      self.player.shuffleIsOn.addObserver(anyObject: self, callback: { [weak self] (oldValue: Bool, newValue: Bool) in
        if newValue {
          self?.shuffleButton.setImage(UIImage(named: "shuffle_inversed"), for: .normal)
        } else {
          self?.shuffleButton.setImage(UIImage(named: "shuffle"), for: .normal)
        }
      })
      self.player.repeatIsOn.addObserver(anyObject: self, callback: { [weak self] (oldValue: Bool, newValue: Bool) in
        if newValue {
          self?.repeatButton.setImage(UIImage(named: "repeat_inversed"), for: .normal)
        } else {
          self?.repeatButton.setImage(UIImage(named: "repeat"), for: .normal)
        }
      })
      self.player.isPlaying.addObserver(anyObject: self, callback: { [weak self] (oldValue: Bool, newValue: Bool) in
        if newValue {
          self?.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
          self?.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
      })
    }
  
    @IBAction func playButtonTapped(_ sender: Any) {
      if !self.player.isPlaying.value {
        self.player.play()
      } else {
        self.player.pause()
      }
    }
  
    @IBAction func nextButtonTapped(_ sender: Any) {
      self.player.next()
      guard self.player.isPlaying.value else {return}
      self.player.play()
    }
  
    @IBAction func previousButtonTapped(_ sender: Any) {
      self.player.previous()
      guard self.player.isPlaying.value else {return}
      self.player.play()
    }
  
    @IBAction func repeatButtonTapped(_ sender: Any) {
      self.player.repeatTrack()
    }
  
    @IBAction func shuffleButtonTapped(_ sender: Any) {
      self.player.shuffle()
    }
  
    private func assignViewModel() {
      let viewModel = TrackInfoViewModel()
      self.viewModel = viewModel
      self.trackInfoView.viewModel = viewModel
    }
  
    private func setUI() {
      self.shuffleButton.layer.cornerRadius = 10.0
      self.shuffleButton.layer.masksToBounds = true
      self.repeatButton.layer.cornerRadius = 10.0
      self.repeatButton.layer.masksToBounds = true
      guard let viewModel = self.viewModel else {return}
      self.totalTimeLabel.text = viewModel.duration.value
      self.currentTimeLabel.text = viewModel.currentTime.value
      self.trackInfoView.albumImageView.image = viewModel.albumImage.value
      self.trackInfoView.albumNameLabel.text = viewModel.albumName.value
      self.trackInfoView.artistNameLabel.text = viewModel.artistName.value
      self.trackInfoView.trackNameLabel.text = viewModel.trackName.value
      self.progressView.progress = viewModel.progress.value ?? 0
    }
}
