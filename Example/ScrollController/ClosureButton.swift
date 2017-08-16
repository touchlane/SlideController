//
//  ClosureButton.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ClosureButton: UIButton {
    
    typealias DidTapButton = () -> ()
    
    var didTouchUpInside: DidTapButton? {
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
