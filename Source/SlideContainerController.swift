//
//  SlideContainerController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

/// SlideContainerController do control for specific container view
final class SlideContainerController {
    private var internalView = InternalView()
    private var isViewLoaded = false

    /// Property to indicate if target view mounted to container
    var hasContent: Bool {
        isViewLoaded
    }

    /// Implements lazy load, add target view as subview to container view when needed and set hasContent = true
    func load(view: UIView) {
        guard !isViewLoaded else {
            return
        }
        isViewLoaded = true
        internalView.addSubview(view)
        view.frame = internalView.bounds
    }

    /// Removes view from container and sets hasContent = false
    func unloadView() {
        guard isViewLoaded else {
            return
        }
        isViewLoaded = false
        internalView.subviews.forEach { $0.removeFromSuperview() }
    }
}

/// Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerController
extension ViewableImplementation: Viewable {
    var view: UIView {
        internalView
    }
}

/// Internal view for SlideContainerController
private final class InternalView: UIView {
    private var oldSize: CGSize = .zero

    override func layoutSubviews() {
        guard oldSize != bounds.size else {
            return
        }
        super.layoutSubviews()

        subviews.first?.frame = bounds
        oldSize = bounds.size
    }
}
