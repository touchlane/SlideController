//
//  TestableLifeCycleObject.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 11/13/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import SlideController
import UIKit

class TestableLifeCycleObject: Initializable {
    // MARK: - InitialazableImplementation

    var didAppearTriggered: Bool = false
    var didDissapearTriggered: Bool = false
    var viewDidLoadTriggered: Bool = false
    var viewDidUnloadTriggered: Bool = false
    var didStartSlidingTriggered: Bool = false
    var didCancelSlidingTriggered: Bool = false

    required init() {}
}

private typealias SlidePageLifeCycleImplementation = TestableLifeCycleObject
extension SlidePageLifeCycleImplementation: SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }

    func didAppear() {
        didAppearTriggered = true
    }

    func didDissapear() {
        didDissapearTriggered = true
    }

    func viewDidLoad() {
        viewDidLoadTriggered = true
    }

    func viewDidUnload() {
        viewDidUnloadTriggered = true
    }

    func didStartSliding() {
        didStartSlidingTriggered = true
    }

    func didCancelSliding() {
        didCancelSlidingTriggered = true
    }
}

private typealias ViewableImplementation = TestableLifeCycleObject
extension ViewableImplementation: Viewable {
    var view: UIView {
        return UIView()
    }
}
