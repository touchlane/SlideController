//
//  ClosureButton.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol Actionable: AnyObject {
    var didTouchUpInside: (() -> Void)? { get set }
}

class ClosureButton: UIButton {
    private var internalDidTouchUpInside: (() -> Void)? {
        didSet {
            if internalDidTouchUpInside != nil {
                addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            }
        }
    }
}

private typealias PrivateClosureButton = ClosureButton
private extension PrivateClosureButton {
    @objc func didTouchUpInside(_ sender: UIButton) {
        didTouchUpInside?()
    }
}

private typealias ActionableImplementation = ClosureButton
extension ActionableImplementation: Actionable {
    var didTouchUpInside: (() -> Void)? {
        get {
            internalDidTouchUpInside
        }
        set {
            internalDidTouchUpInside = newValue
        }
    }
}
