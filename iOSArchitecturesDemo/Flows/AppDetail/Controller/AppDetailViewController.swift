//
//  AppDetailViewController.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 20.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import UIKit



class ITunesAppAdapter: HeaderInfo {
    private let app: ITunesApp
    private let imageDownloader = ImageDownloader()
    
    init(app: ITunesApp) {
        self.app = app
    }
    
    
    func loadImage(completion: @escaping (UIImage?) -> Void ) {
        guard let url = self.app.iconUrl else {
            completion(nil)
            return
        }
        self.imageDownloader.getImage(fromUrl: url) { (image, error) in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func title() -> String {
        return app.appName
    }
    
    func description() -> String {
        return app.appDescription ?? ""
    }
}




final class AppDetailViewController: UIViewController {
    
    private var headerViewController: HeaderInfoViewController?
    private var headerView: UIView?
    
    public var app: ITunesApp? {
        didSet {
            self.updateHeader()
        }
    }
    
    private let imageDownloader = ImageDownloader()
    
    private var appDetailView: AppDetailView {
        return self.view as! AppDetailView
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        self.view = AppDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationController()
        self.downloadImage()
        self.addHeader()
    }
    
    // MARK: - Private
    
    private func addHeader() {
        if nil != self.headerViewController {
            return
        }
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        self.headerView = headerView
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)])

        headerView.addConstraint( NSLayoutConstraint(item: headerView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: 200) )
        
         
        let headerViewController = HeaderInfoViewController()
        self.addChild(headerViewController)
        headerViewController.didMove(toParent: self)
        headerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerViewController.view)
        self.headerViewController = headerViewController
        
        NSLayoutConstraint.activate([
        headerViewController.view.topAnchor.constraint(equalTo: headerView.topAnchor),
        headerViewController.view.leftAnchor.constraint(equalTo: headerView.leftAnchor),
        headerViewController.view.rightAnchor.constraint(equalTo: headerView.rightAnchor),
        headerViewController.view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)])
        
        self.updateHeader()
    }
    
    private func updateHeader() {
        if let app = self.app {
            self.headerViewController?.headerInfo = ITunesAppAdapter(app: app)
        }
    }
    
    private func configureNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func downloadImage() {
//        guard let url = self.app?.iconUrl else { return }
//        self.appDetailView.throbber.startAnimating()
//        self.imageDownloader.getImage(fromUrl: url) { (image, error) in
//            self.appDetailView.throbber.stopAnimating()
//            guard let image = image else { return }
//            self.appDetailView.imageView.image = image
//        }
    }
}
