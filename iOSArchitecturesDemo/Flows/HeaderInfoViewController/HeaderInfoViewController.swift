//
//  HeaderInfoViewController.swift
//  iOSArchitecturesDemo
//
//  Created by Stanislav Ivanov on 23.10.2019.
//  Copyright © 2019 ekireev. All rights reserved.
//

import UIKit


protocol HeaderInfo {
    func loadImage(completion: @escaping (UIImage?) -> Void )
    
    func title() -> String
    func description() -> String
}



class HeaderInfoViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel:       UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var iconImageView:    UIImageView?

    
    var headerInfo: HeaderInfo? {
        didSet {
            self.titleLabel?.text = self.headerInfo?.title()
            self.descriptionLabel?.text = self.headerInfo?.description()
            self.headerInfo?.loadImage(completion: { [weak self] (image: UIImage?) in
                self?.iconImageView?.image = image
            })
        }
    }
}
