//
//  ScrollPageLifeCycleObject.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ScrollPageLifeCycleObject : Initializable {
    
    fileprivate var _view : UIView
    
    //MARK: - Initialazable_Implementation
    
    required init() {
        _view = UIView()
        _view.backgroundColor = UIColor.white
    }
}

private typealias PageScrollViewLifeCycle_Implementation = ScrollPageLifeCycleObject
extension PageScrollViewLifeCycle_Implementation : PageScrollViewLifeCycle {
    var isKeyboardResponsive : Bool {
        return false
    }
    
    var title : String? {
        return nil
    }
    
    func didAppear() {
        print("Empty page did appear")
    }
    
    func didDissapear() {
        print("Empty page did dissapear")
    }
    
    func viewDidLoad() {
        
    }
    
    func didStartScrolling() {
        
    }
    
    func didCancelScrolling() {
        
    }
}

private typealias Viewable_Implementation = ScrollPageLifeCycleObject
extension Viewable_Implementation : Viewable {
    var view : UIView {
        get {
            return _view
        }
    }
}



