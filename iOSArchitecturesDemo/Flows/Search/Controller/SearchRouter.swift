//
//  SearchRouter.swift
//  iOSArchitecturesDemo
//
//  Created by Anastasia Romanova on 05/11/2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit

protocol SearchRouterProtocol {
  func openDetails(for app: ITunesApp, in viewController: UIViewController)
}

class SearchRouter: SearchRouterProtocol {
  
  func openDetails(for app: ITunesApp, in viewController: UIViewController) {
    let appDetaillViewController = AppDetailViewController()
    appDetaillViewController.app = app
    viewController.navigationController?.pushViewController(
      appDetaillViewController, animated: true)
  }
}
