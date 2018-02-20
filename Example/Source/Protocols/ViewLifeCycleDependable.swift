//
//  ViewLifeCycleDependable.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 9/20/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

protocol ViewLifeCycleDependable: class {
    func viewDidAppear()
    func viewDidDisappear()
}
