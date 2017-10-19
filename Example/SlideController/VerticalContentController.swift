//
//  VerticalContentController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class VerticalContentController {
    private let internalView = VerticalContentView()
    
    var menuDidTapAction: (() -> Void)? {
        didSet {
            self.internalView.menuButton.didTouchUpInside = self.menuDidTapAction
        }
    }
}

private typealias ViewableImplementation = VerticalContentController
extension ViewableImplementation: ViewAccessible {
    var view: UIView {
        return self.internalView
    }
}
