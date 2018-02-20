//
//  ClosureButtonDesignable.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol ButtonDesignable: class {
    var textFont: UIFont { get }
    var textColor: UIColor { get }
    var bgColor: UIColor { get }
}

extension ButtonDesignable {
    var textFont: UIFont {
        return UIFont.systemFont(ofSize: 15)
    }
    
    var textColor: UIColor {
        return UIColor.white
    }
    
    var bgColor: UIColor {
        return UIColor.purple
    }
}
