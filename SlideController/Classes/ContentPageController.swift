//
//  ContentPageController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ContentPageController {
    let view = UIView()
    
    func isContentLoaded() -> Bool {
        if view.subviews.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    func load(childView: UIView) {
        if !isContentLoaded() {
            childView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(childView)
            NSLayoutConstraint.activate([
                childView.topAnchor.constraint(equalTo: view.topAnchor),
                childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                childView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}

