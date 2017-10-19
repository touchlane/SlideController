//
//  VerticalPageLifeCycleObject.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class VerticalPageLifeCycleObject: Initializable {
    private var controller = ColorController()
    
    required init() { }
}

private typealias SlidePageLifeCycleImplementation = VerticalPageLifeCycleObject
extension SlidePageLifeCycleImplementation: SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }
    
    func didAppear() { }
    
    func didDissapear() { }
    
    func viewDidLoad() { }
    
    func didStartSliding() { }
    
    func didCancelSliding() { }
}

private typealias ViewableImplementation = VerticalPageLifeCycleObject
extension ViewableImplementation: Viewable {
    var view: UIView {
        get {
            return controller.view
        }
    }
}
