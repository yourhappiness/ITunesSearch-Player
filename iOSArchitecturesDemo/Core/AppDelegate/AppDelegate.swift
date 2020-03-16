//
//  AppDelegate.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 14.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appStartManager: AppStartManager?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.appStartManager = AppStartManager(window: self.window)
        self.appStartManager?.start()
        return true
    }
    
    
    // S - Принцип единой ответственности
    // O - Открытость\закрытости
    // L - Лисков
    // I - Интерфейсы
    // D - Инверсия зависимостей
    
    
    // Entity
    // Interactor
    // Presenter
    // View
    
    
    
    
    
//    1 Переписать экран поиска по песням (из предыдущего практического задания) на архитектуру VIPER.
//    2 * Сделать экран проигрывания песни. По-настоящему звук можно не проигрывать, просто сделать сервис, аналогичный FakeDownloadAppsService с урока. По MVVM сделать экран с обновлением UI по ходу проигрывания песни. Дизайн в минимальном виде повторите из нативного приложения «Музыка».
//    3 ** В интеракторах модулей реализуйте логику сохранения полученных данных в кеш.

}

