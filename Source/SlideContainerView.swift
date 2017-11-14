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
    
    ///Constraints for internal view, allow to change UI positioning for container view
    var constraints = [NSLayoutConstraint]()
    
    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        internalView = view
    }
}

///Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerView
extension ViewableImplementation: Viewable {
    var view: UIView {
        return internalView
    }
}
