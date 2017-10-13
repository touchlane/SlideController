//
//  OptionsController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol OptionsControllerProtocol : class {
    var openHorizontalDemoAction: (() -> ())? { get set }
    var openVerticalDemoAction: (() -> ())? { get set }
}

class OptionsController {
    private let internalView = OptionsView()
}

private typealias OptionsControllerProtocolImplementation = OptionsController
extension OptionsControllerProtocolImplementation : OptionsControllerProtocol {
    var openHorizontalDemoAction: (() -> ())? {
        get {
            return internalView.horizontalDemoBtn.didTouchUpInside
        }
        set {
            internalView.horizontalDemoBtn.didTouchUpInside = newValue
        }
    }
    
    var openVerticalDemoAction: (() -> ())? {
        get {
            return internalView.verticalDemoBtn.didTouchUpInside
        }
        set {
            internalView.verticalDemoBtn.didTouchUpInside = newValue
        }
    }
}

private typealias ViewAccessibleImplementation = OptionsController
extension ViewAccessibleImplementation : ViewAccessible {
    var view: UIView {
        get {
            return internalView
        }
    }
}
