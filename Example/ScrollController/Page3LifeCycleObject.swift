//
//  Page3LifeCycleObject.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import ScrollController

class Page3LifeCycleObject : Initializable {
    
    fileprivate var _controller = ColorController()
    
    //MARK: - Initialazable_Implementation
    
    required init() {
        
    }
}

private typealias PageScrollViewLifeCycle_Implementation = Page3LifeCycleObject
extension PageScrollViewLifeCycle_Implementation : PageScrollViewLifeCycle {
    func didAppear() {
        print("Page 3 did appear")
    }
    
    func didDissapear() {
        print("Page 3 did dissapear")
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

private typealias Viewable_Implementation = Page3LifeCycleObject
extension Viewable_Implementation : Viewable {
    var view : UIView {
        get {
            return _controller.view
        }
    }
}
