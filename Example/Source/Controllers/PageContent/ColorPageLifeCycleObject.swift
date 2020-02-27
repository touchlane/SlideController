//
//  ColorPageLifeCycleObject.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import SlideController
import UIKit

class ColorPageLifeCycleObject: Initializable {
    var controller = ColorController()

    // MARK: - InitialazableImplementation

    required init() {}
}

private typealias SlideColorPageLifeCycleImplementation = ColorPageLifeCycleObject
extension SlideColorPageLifeCycleImplementation: SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }

    func didAppear() {}

    func didDissapear() {}

    func viewDidLoad() {}

    func viewDidUnload() {}

    func didStartSliding() {}

    func didCancelSliding() {}
}

private typealias ViewableImplementation = ColorPageLifeCycleObject
extension ViewableImplementation: Viewable {
    var view: UIView {
        return controller.view
    }
}
