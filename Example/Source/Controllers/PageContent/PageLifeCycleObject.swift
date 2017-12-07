//
//  PageLifeCycleObject.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class PageLifeCycleObject : Initializable {
    private var controller = ColorController()
    
    // MARK: - InitialazableImplementation
    
    required init() {
    
    }
}

private typealias SlidePageLifeCycleImplementation = PageLifeCycleObject
extension SlidePageLifeCycleImplementation : SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }
    
    func didAppear() {
        print(#function)
        sleep(1)
    }
    
    func didDissapear() {
        print(#function)
    }
    
    func viewDidLoad() {
        print(#function)
    }
    
    func viewDidUnload() {
        print(#function)
    }
    
    func didStartSliding() {
        print(#function)
    }
    
    func didCancelSliding() {
        print(#function)
    }
}

private typealias ViewableImplementation = PageLifeCycleObject
extension ViewableImplementation : Viewable {
    var view: UIView {
        get {
            return controller.view
        }
    }
}
