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

private typealias PageScrollViewLifeCycle_Implementation = PageLifeCycleObject
extension PageScrollViewLifeCycle_Implementation : SlidePageLifeCycle {
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
    
    func didStartScrolling() {
        
    }
    
    func didCancelScrolling() {
        
    }
}

private typealias Viewable_Implementation = PageLifeCycleObject
extension Viewable_Implementation : SlideController.Viewable {
    var view : UIView {
        get {
            return _controller.view
        }
    }
}
