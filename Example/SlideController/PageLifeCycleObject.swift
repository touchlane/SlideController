//
//  PageLifeCycleObject.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class PageLifeCycleObject : Initializable {
    private var controller = ColorController()
    
    //MARK: - InitialazableImplementation
    
    required init() {
    
    }
}

private typealias SlidePageLifeCycleImplementation = PageLifeCycleObject
extension SlidePageLifeCycleImplementation : SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }
    
    func didAppear() { }
    
    func didDissapear() { }
    
    func viewDidLoad() { }
    
    func didStartSliding() { }
    
    func didCancelSliding() { }
}

private typealias ViewableImplementation = PageLifeCycleObject
extension ViewableImplementation : Viewable {
    var view: UIView {
        get {
            return controller.view
        }
    }
}
