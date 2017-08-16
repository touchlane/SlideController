//
//  LifecycleContentUIViewController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SnapKit
import ScrollController

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
        activateControllerViewConstraints(view: _controller.view)
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
    
    func activateControllerViewConstraints(view : UIView) {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
