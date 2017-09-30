//
//  ClosureButton.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

protocol Actionable : class {
    var didTouchUpInside: (() -> ())? { get set }
}

class ClosureButton: UIButton {
    private var internalDidTouchUpInside: (() -> ())? {
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
extension ActionableImplementation : Actionable {
     var didTouchUpInside: (() -> ())? {
        get {
            return internalDidTouchUpInside
        }
        set {
            internalDidTouchUpInside = newValue
        }
    }
}
