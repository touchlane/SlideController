//
//  OptionsController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

protocol OptionsControllerProtocol : class {
    var openHorizontalDemoAction: (() -> ())? { get set }
    var openVerticalDemoAction: (() -> ())? { get set }
}

class OptionsController {
    fileprivate let _view = OptionsView()
}

private typealias OptionsControllerProtocol_Implementation = OptionsController
extension OptionsControllerProtocol_Implementation : OptionsControllerProtocol {
    var openHorizontalDemoAction: (() -> ())? {
        get {
            return _view.horizontalDemoBtn.didTouchUpInside
        }
        set {
            _view.horizontalDemoBtn.didTouchUpInside = newValue
        }
    }
    
    var openVerticalDemoAction: (() -> ())? {
        get {
            return _view.verticalDemoBtn.didTouchUpInside
        }
        set {
            _view.verticalDemoBtn.didTouchUpInside = newValue
        }
    }
}

private typealias Viewable_Implementation = OptionsController
extension Viewable_Implementation : Viewable {
    var view : UIView {
        get {
            return _view
        }
    }
}
