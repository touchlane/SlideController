//
//  ContentUIViewController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/20/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class ContentUIViewController<T>: UIViewController where T: ViewAccessible {
    var controller: T? {
        didSet {
            guard let controller = controller else {
                return
            }
            view = controller.view
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
