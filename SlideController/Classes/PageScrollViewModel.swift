//
//  PageScrollViewModel.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

public class PageScrollViewModel {
    
    public var object : ScrollLifeCycleObject {
        return buildObjectIfNeeded()
    }
    
    fileprivate var className : String?
    fileprivate var internalObject : ScrollLifeCycleObject?
    
    public init(className : String) {
        self.className = className
    }
    
    public  init(object : ScrollLifeCycleObject?) {
        internalObject = object
    }
}

private typealias Private_PageScrollViewModel = PageScrollViewModel
extension Private_PageScrollViewModel  {
    
    func buildObjectIfNeeded() -> ScrollLifeCycleObject {
        if let object = internalObject {
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
