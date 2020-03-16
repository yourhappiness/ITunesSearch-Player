//
//  AppStartConfigurator.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 19.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

final class AppStartManager {
    
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let rootVC = SearchViewController()
        rootVC.navigationItem.title = "Search via iTunes"
        
        let navVC = self.configuredNavigationController
        navVC.viewControllers = [rootVC]
        navVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
      
        let playerVC = PlayerViewController()
        playerVC.navigationItem.title = "Player"
        playerVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [navVC, playerVC]
        tabBarVC.selectedIndex = 0
      
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
    
    private lazy var configuredNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        navVC.navigationBar.barTintColor = UIColor.varna
        navVC.navigationBar.isTranslucent = false
        navVC.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navVC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        return navVC
    }()
}
