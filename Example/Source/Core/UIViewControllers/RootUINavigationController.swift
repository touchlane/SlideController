//
//  RootUINavigationController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/9/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class RootUINavigationController: UINavigationController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationBar.barTintColor = .purple
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
