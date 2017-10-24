//
//  BottomBarController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class HorizontalOptionsController: ContentActionable {
    private let internalView = HorizontalOptionsView()
    
    var changePositionAction: ((Int) -> ())? {
        didSet {
            internalView.changePositionAction = changePositionAction
        }
    }
    
    // MARK: ContentActionableImplementation
    
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
    
    var appendDidTapAction: ContentActionable.Action? {
        didSet {
            internalView.appendButton.didTouchUpInside = appendDidTapAction
        }
    }
    
    var menuDidTapAction: ContentActionable.Action? {
        didSet {
            internalView.menuButton.didTouchUpInside = menuDidTapAction
        }
    }
}

private typealias ViewableImplementation = HorizontalOptionsController
extension ViewableImplementation : ViewAccessible {
    var view : UIView {
        return internalView
    }
}
