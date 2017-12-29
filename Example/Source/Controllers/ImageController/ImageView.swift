//
//  ImageView.swift
//  Example
//
//  Created by Vadim Morozov on 12/28/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class ImageView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private let imageView = UIImageView()
    
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.white
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        activateImageViewConstraints(view: imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias PrivateImageView = ImageView
private extension PrivateImageView {
    func activateImageViewConstraints (view: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
