//
//  BottomBarController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class LogoutController {
    
    fileprivate let _view = LogoutView()
    
    var logOutDidTapAction: (() -> ())? {
        didSet {
            _view.logOutBtn.didTouchUpInside = logOutDidTapAction
        }
    }
}

private typealias Viewable_Implementation = LogoutController
extension Viewable_Implementation : Viewable {
    
    var view : UIView {
        return _view
    }
}
