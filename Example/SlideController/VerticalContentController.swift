//
//  VerticalContentController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class VerticalContentController: ContentActionable {
    private let internalView = VerticalContentView()
    
    var removeDidTapAction: Action? {
        didSet {
            internalView.removeButton.didTouchUpInside = removeDidTapAction
        }
    }
    
    var insertDidTapAction: Action? {
        didSet {
            internalView.insertButton.didTouchUpInside = insertDidTapAction
        }
    }
    
    var appendDidTapAction: Action? {
        didSet {
            internalView.appendButton.didTouchUpInside = appendDidTapAction
        }
    }
    
    var menuDidTapAction: Action? {
        didSet {
            internalView.menuButton.didTouchUpInside = menuDidTapAction
        }
    }
}

private typealias ViewableImplementation = VerticalContentController
extension ViewableImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}
