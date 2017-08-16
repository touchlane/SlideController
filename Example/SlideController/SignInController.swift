//
//  SignInController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import ScrollController

class SignInController {
    
    fileprivate let _view = SignInView()
    
    var signInDidTapAction: (() -> ())? {
        didSet {
            _view.signInBtn.didTouchUpInside = signInDidTapAction
        }
    }
}

private typealias Viewable_Implementation = SignInController
extension Viewable_Implementation : Viewable {
    
    var view : UIView {
        return _view
    }
}
