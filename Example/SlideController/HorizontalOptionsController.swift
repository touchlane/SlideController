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
    
    var logOutDidTapAction: (() -> ())? {
        didSet {
            internalView.logOutBtn.didTouchUpInside = logOutDidTapAction
        }
    }
}

private typealias ViewableImplementation = HorizontalOptionsController
extension ViewableImplementation : ViewAccessible {
    var view : UIView {
        return internalView
    }
}
