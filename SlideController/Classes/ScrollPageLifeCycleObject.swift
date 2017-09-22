//
//  ScrollPageLifeCycleObject.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ScrollPageLifeCycleObject: Initializable {
    
    fileprivate var objectView: UIView
    
    // MARK: - InitialazableImplementation
    required init() {
        objectView = UIView()
        objectView.backgroundColor = UIColor.white
    }
}

private typealias PageScrollViewLifeCycleImplementation = ScrollPageLifeCycleObject
extension PageScrollViewLifeCycleImplementation: PageScrollViewLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
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

private typealias ViewableImplementation = ScrollPageLifeCycleObject
extension ViewableImplementation: Viewable {
    var view: UIView {
        get {
            return objectView
        }
    }
}



