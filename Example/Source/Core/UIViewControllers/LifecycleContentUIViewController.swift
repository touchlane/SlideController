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
            setupNavigationBar(controller: controller)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let controller = controller {
            setupNavigationBar(controller: controller)
        }
        super.viewWillAppear(animated)
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

private typealias LifecycleContentUIViewControllerPrivate = LifecycleContentUIViewController
private extension LifecycleContentUIViewControllerPrivate {
    func setupNavigationBar(controller: T) {
        navigationItem.hidesBackButton = true
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 2
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowColor = UIColor(white: 0.5, alpha: 0.5)
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: controller.titleColor,
            NSAttributedStringKey.shadow: shadow
        ]
    }
}
