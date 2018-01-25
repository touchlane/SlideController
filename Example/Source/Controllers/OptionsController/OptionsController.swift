//
//  OptionsController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol OptionsControllerProtocol: class {
    var openHorizontalDemoAction: (() -> Void)? { get set }
    var openVerticalDemoAction: (() -> Void)? { get set }
    var openCircularDemoAction: (() -> Void)? { get set }
}

class OptionsController {
    private let internalView = OptionsView()
}

private typealias OptionsControllerProtocolImplementation = OptionsController
extension OptionsControllerProtocolImplementation : OptionsControllerProtocol {
    var openHorizontalDemoAction: (() -> Void)? {
        get {
            return internalView.horizontalDemoButton.didTouchUpInside
        }
        set {
            internalView.horizontalDemoButton.didTouchUpInside = newValue
        }
    }
    
    var openVerticalDemoAction: (() -> Void)? {
        get {
            return internalView.verticalDemoButton.didTouchUpInside
        }
        set {
            internalView.verticalDemoButton.didTouchUpInside = newValue
        }
    }
    
    var openCircularDemoAction: (() -> Void)? {
        get {
            return internalView.circularDemoButton.didTouchUpInside
        }
        set {
            internalView.circularDemoButton.didTouchUpInside = newValue
        }
    }
}

private typealias ViewAccessibleImplementation = OptionsController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        get {
            return internalView
        }
    }
}

private typealias StatusBarAccessibleImplementation = OptionsController
extension StatusBarAccessibleImplementation: StatusBarAccessible {
    var statusBarStyle: UIStatusBarStyle {
        return .default
    }
}
