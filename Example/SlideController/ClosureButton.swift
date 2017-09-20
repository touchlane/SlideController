//
//  ClosureButton.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

protocol Actionable : class {
    var didTouchUpInside: (() -> ())? { get set }
}

class ClosureButton: UIButton {
    fileprivate var _didTouchUpInside: (() -> ())? {
        didSet {
            if didTouchUpInside != nil {
                addTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            } else {
                removeTarget(self, action: #selector(didTouchUpInside(_:)), for: .touchUpInside)
            }
        }
    }
}

private typealias Private_ClosureButton = ClosureButton
private extension Private_ClosureButton {
    @objc func didTouchUpInside(_ sender: UIButton) {
        didTouchUpInside?()
    }
}

private typealias Actionable_Implementation = ClosureButton
extension Actionable_Implementation : Actionable {
     var didTouchUpInside: (() -> ())? {
        get {
            return _didTouchUpInside
        }
        set {
            _didTouchUpInside = newValue
        }
    }
}
