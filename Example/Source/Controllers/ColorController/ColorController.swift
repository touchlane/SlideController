//
//  ColorController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import SlideController
import UIKit

class ColorController {
    private let internalView = ColorView()
}

private typealias ViewableImplementation = ColorController
extension ViewableImplementation: Viewable {
    var view: UIView {
        return internalView
    }
}
