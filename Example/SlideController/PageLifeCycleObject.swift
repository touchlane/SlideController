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
    fileprivate var _controller = ColorController()
    
    //MARK: - Initialazable_Implementation
    
    required init() {
    
    }
}

private typealias SlidePageLifeCycleImplementation = PageLifeCycleObject
extension SlidePageLifeCycleImplementation : SlidePageLifeCycle {
    var isKeyboardResponsive : Bool {
        return false
    }
    
    func didAppear() {
        print("Page did appear")
    }
    
    func didDissapear() {
        print("Page did dissapear")
    }
    
    func viewDidLoad() {
        
    }
    
    func didStartSliding() {
        
    }
    
    func didCancelSliding() {
        
    }
}

private typealias Viewable_Implementation = PageLifeCycleObject
extension Viewable_Implementation : Viewable {
    var view : UIView {
        get {
            return _controller.view
        }
    }
}
