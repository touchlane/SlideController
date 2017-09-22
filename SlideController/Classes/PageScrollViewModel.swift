//
//  PageScrollViewModel.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

public class PageScrollViewModel {
    
    public var lifeCycleObject: ScrollLifeCycleObject { get {return buildObjectIfNeeded() } }
    
    fileprivate var className: String?
    fileprivate var object: ScrollLifeCycleObject?
    
    public init(className: String) {
        self.className = className
    }
    
    public  init(object: ScrollLifeCycleObject) {
        self.object = object
    }
}

private typealias PrivatePageScrollViewModel = PageScrollViewModel
extension PrivatePageScrollViewModel  {
    
    func buildObjectIfNeeded() -> ScrollLifeCycleObject {
        if let object = object {
            return object
        } else {
            if let classInst = NSClassFromString(className!) as? Initializable.Type {
                if let object = classInst.init() as? ScrollLifeCycleObject {
                    return object
                }
            }
        }
        return ScrollPageLifeCycleObject()
    }
    
}
