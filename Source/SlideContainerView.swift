//
//  SlideContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

///Represents container view for one page content
final class SlideContainerView {
    private var internalView: UIView
    private let containerView = UIView()
    
    ///Constraints for internal view, allow to change UI positioning for container view
    var constraints = [NSLayoutConstraint]()
    
    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            view.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        internalView = view
    }
}

///Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerView
extension ViewableImplementation: Viewable {
    var view: UIView {
        return containerView
    }
}
