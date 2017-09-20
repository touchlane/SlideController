//
//  BottomBarController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class HorizontalOptionsController {
    fileprivate let _view = HorizontalOptionsView()
    
    var logOutDidTapAction: (() -> ())? {
        didSet {
            _view.logOutBtn.didTouchUpInside = logOutDidTapAction
        }
    }
}

private typealias Viewable_Implementation = HorizontalOptionsController
extension Viewable_Implementation : Viewable {
    var view : UIView {
        return _view
    }
}
