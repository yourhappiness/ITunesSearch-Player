//
//  SearchViewInteractorProtocol.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 05/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import Foundation

protocol SearchViewInteractorProtocol {

  func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void )
  
  func setRouter(_ searchRouter: SearchRouterProtocol)
}


class SearchViewInteractorForApps: SearchViewInteractorProtocol { //Interactor
  
  private let searchService: ITunesSearchService
  private var searchRouter: SearchRouterProtocol?
  
  init(searchService: ITunesSearchService) {
    self.searchService = searchService
  }
  
  convenience init() {
    self.init(searchService: ITunesSearchService())
  }
  
  func setRouter(_ searchRouter: SearchRouterProtocol) {
    self.searchRouter = searchRouter
  }
  
  func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void ) {
    
    var searchResults: [SearchItemProtocol] = []
    
    self.searchService.getApps(forQuery: query) { result in
      
      result
        .withValue { apps in
          
          for app in apps {
            let searchItem = SearchItemAppAdapter(app: app, router: self.searchRouter)
            searchResults.append(searchItem)
          }
          
          completion(searchResults, nil)
        }
        .withError {_ in
          completion(searchResults, nil)
      }
    }
  }
}

class SearchViewInteractorForSongs: SearchViewInteractorProtocol { //Interactor
  
  private let searchService: ITunesSearchService
  private var searchRouter: SearchRouterProtocol?
  
  init(searchService: ITunesSearchService) {
    self.searchService = searchService
  }
  
  convenience init() {
    self.init(searchService: ITunesSearchService() )
  }
  
  func setRouter(_ searchRouter: SearchRouterProtocol) {
    self.searchRouter = searchRouter
  }
  
  func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void ) {
    
    var searchResults: [SearchItemProtocol] = []
    
    self.searchService.getSongs(forQuery: query) { result in
      
      result
        .withValue { songs in
          
          for song in songs {
            let searchItem = SearchItemSongAdapter(song: song, router: self.searchRouter)
            searchResults.append(searchItem)
          }
          
          completion(searchResults, nil)
        }
        .withError {_ in
          completion(searchResults, nil)
      }
    }
  }
}
