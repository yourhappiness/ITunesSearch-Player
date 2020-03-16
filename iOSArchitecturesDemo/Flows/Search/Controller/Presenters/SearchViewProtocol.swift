//
//  SearchViewProtocol.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 05/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchViewProtocol {
  
  func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void )
}

class SearchViewITunesServiceAdapter: SearchViewProtocol { //Presenter
  
  private let interactor: SearchViewInteractorProtocol
  private let router: SearchRouterProtocol = SearchRouter()
  
  init(interactor: SearchViewInteractorProtocol) {
    self.interactor = interactor
    self.interactor.setRouter(self.router)
  }
  
  func loadData(query: String, completion: @escaping ([SearchItemProtocol], Error?) -> Void ) {
    self.interactor.loadData(query: query, completion: completion)
  }
  
}




