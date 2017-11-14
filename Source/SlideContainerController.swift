//
//  SlideContainerController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

///SlideContainerController do control for specific container view
final class SlideContainerController {
    private var internalView = UIView()
    private var isViewLoaded = false
    
    ///Property to indicate if target view mounted to container
    var hasContent: Bool {
        return isViewLoaded
    }
    
    ///Implements lazy load, add target view as subview to container view when needed and set hasContent = true
    func load(view: UIView) {
        guard !isViewLoaded else {
            return
        }
        isViewLoaded = true
        view.translatesAutoresizingMaskIntoConstraints = false
        internalView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: internalView.topAnchor),
            view.leadingAnchor.constraint(equalTo: internalView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: internalView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: internalView.trailingAnchor)
        ])
    }
    
    ///Removes view from container and sets hasContent = false
    func unloadView() {
        guard isViewLoaded else {
            return
        }
        isViewLoaded = false
        internalView.subviews.forEach({ $0.removeFromSuperview() })
    }
}

///Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerController
extension ViewableImplementation: Viewable {
    var view: UIView {
        return internalView
    }
}
