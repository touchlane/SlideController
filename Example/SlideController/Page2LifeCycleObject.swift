//
//  Page2LifeCycleObject.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class Page2LifeCycleObject : Initializable {
    
    fileprivate var _controller = ColorController()
    
    //MARK: - Initialazable_Implementation
    
    required init() {
        
    }
}

private typealias PageScrollViewLifeCycle_Implementation = Page2LifeCycleObject
extension PageScrollViewLifeCycle_Implementation : PageScrollViewLifeCycle {
    func didAppear() {
        print("Page 2 did appear")
    }
    
    func didDissapear() {
        print("Page 2 did dissapear")
    }
    
    var isKeyboardResponsive : Bool {
        return false
    }
    
    func viewDidLoad() {
        
    }
    
    func didStartScrolling() {
        
    }
    
    func didCancelScrolling() {
        
    }
}

private typealias Viewable_Implementation = Page2LifeCycleObject
extension Viewable_Implementation : Viewable {
    var view : UIView {
        get {
            return _controller.view
        }
    }
}
