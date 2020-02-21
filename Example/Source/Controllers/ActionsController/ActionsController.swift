//
//  ActionsController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class ActionsController: ContentActionable {
    private let internalView = ActionsView()

    // MARK: ContentActionableImplementation

    var isShowAdvancedActions: Bool {
        get {
            internalView.isShowAdvancedActions
        }
        set {
            internalView.isShowAdvancedActions = newValue
        }
    }

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

    var changePositionAction: ((Int) -> Void)? {
        didSet {
            internalView.changePositionAction = changePositionAction
        }
    }
}

private typealias ViewAccessibleImplementation = ActionsController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        internalView
    }
}
