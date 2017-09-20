//
//  LifecycleContentUIViewController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class LifecycleContentUIViewController <T> : UIViewController where T : Viewable, T : ViewLifeCycleDependable {
    var controller : T? {
        didSet {
            if let controller = controller {
                view = controller.view
            }
        }
    }
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        controller?.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        controller?.viewDidDisappear()
    }
}

