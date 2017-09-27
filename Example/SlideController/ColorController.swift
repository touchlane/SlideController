//
//  ColorController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class ColorController {
    private let internalView = ColorView()
}

private typealias ViewableImplementation = ColorController
extension ViewableImplementation : Viewable {
    var view: UIView {
        return internalView
    }
}
