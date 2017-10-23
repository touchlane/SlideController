//
//  BottomBarController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class HorizontalOptionsController {
    private let internalView = HorizontalOptionsView()
    
    var menuDidTapAction: (() -> ())? {
        didSet {
            internalView.menuBtn.didTouchUpInside = menuDidTapAction
        }
    }
    
    var changePositionAction: ((Int) -> ())? {
        didSet {
            internalView.changePositionAction = changePositionAction
        }
    }
}

private typealias ViewableImplementation = HorizontalOptionsController
extension ViewableImplementation : ViewAccessible {
    var view : UIView {
        return internalView
    }
}
