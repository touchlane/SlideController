//
//  ContentUIViewController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/20/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class ContentUIViewController<T> : UIViewController where T : ViewAccessible {
    var controller : T? {
        didSet {
            if let controller = controller {
                view = controller.view
            }
        }
    }
}
