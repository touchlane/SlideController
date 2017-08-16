//
//  PageScrollViewModel.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

class PageScrollViewModel {
    
    var object : ScrollLifeCycleObject { get {return buildObjectIfNeeded() } }
    
    fileprivate var _className : String?
    fileprivate var _object : ScrollLifeCycleObject?
    
    init(className : String) {
        _className = className
    }
    
    init(object : ScrollLifeCycleObject?) {
        _object = object
    }
}

private typealias Private_PageScrollViewModel = PageScrollViewModel
extension Private_PageScrollViewModel  {
    
    func buildObjectIfNeeded() -> ScrollLifeCycleObject {
        if let object = _object {
            return object
        } else {
            if let classInst = NSClassFromString(_className!) as? Initializable.Type {
                if let object = classInst.init() as? ScrollLifeCycleObject {
                    return object
                }
            }
        }
        return ScrollPageLifeCycleObject()
    }
    
}
