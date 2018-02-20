//
//  LifecycleContentUIViewController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class LifecycleContentUIViewController<T>: UIViewController where T: ViewAccessible & StatusBarAccessible & ViewLifeCycleDependable & TitleDesignable {
    var controller: T? {
        didSet {
            guard let controller = controller else {
                return
            }
            //Bad design, but this is just a demo :)
            view = controller.view
            title = controller.title
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        controller?.viewDidDisappear()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return controller?.statusBarStyle ?? .default
    }
}
