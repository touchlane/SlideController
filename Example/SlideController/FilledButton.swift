//
//  FilledButton.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import CoreGraphics
import Foundation

class FilledButton: ClosureButton, ButtonDesignable {
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = bgColor
        titleLabel?.textColor = textColor
        titleLabel?.font = textFont
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
