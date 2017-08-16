//
//  ColorController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class ColorController {
    fileprivate let _view = ColorView()
}

private typealias Viewable_Implementation = ColorController
extension Viewable_Implementation : Viewable {
    
    var view : UIView {
        return _view
    }
}
