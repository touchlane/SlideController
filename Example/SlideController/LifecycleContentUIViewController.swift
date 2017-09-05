//
//  LifecycleContentUIViewController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

protocol ViewLifeCycleDependable {
    func viewDidAppear()
    func viewDidDisappear()
}

class LifecycleContentUIViewController <T> : UIViewController where T : Viewable, T : ViewLifeCycleDependable {
    
    private let _controller : T
    
    init(controller : T) {
        _controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = false
        _controller.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(_controller.view)
        activateControllerViewConstraints(view: _controller.view, superView: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _controller.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        _controller.viewDidDisappear()
    }
}

private extension LifecycleContentUIViewController {
    
    func activateControllerViewConstraints(view : UIView, superView : UIView) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.bottomAnchor.constraint(equalTo: superView.bottomAnchor))
        constraints.append(view.leadingAnchor.constraint(equalTo: superView.leadingAnchor))
        constraints.append(view.trailingAnchor.constraint(equalTo: superView.trailingAnchor))
        constraints.append(view.topAnchor.constraint(equalTo: superView.topAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}
