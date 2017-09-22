//
//  PageScrollViewModel.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

public protocol ScrollLifeCycleObjectProvidable : class {
    var object : ScrollLifeCycleObject { get }
}

public class PageScrollViewModel<T : ScrollLifeCycleObject> : ScrollLifeCycleObjectProvidable {
    fileprivate var _object : T?
    
    public init() {
        
    }
    
    public init(object : T) {
        _object = object
    }
    
    //MARK: - ScrollLifeCycleObjectGeneratableImplementation
    
    public var object : ScrollLifeCycleObject { get {return buildObjectIfNeeded() } }
}

private typealias Private_PageScrollViewModel = PageScrollViewModel
extension Private_PageScrollViewModel  {
    func buildObjectIfNeeded() -> ScrollLifeCycleObject {
        if let object = _object {
            return object
        }
        _object = T()
        return _object!
    }
}
