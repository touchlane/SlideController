//
//  PageScrollViewModel.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

public protocol SlideLifeCycleObjectProvidable : class {
    var lifeCycleObject : SlideLifeCycleObject { get }
}

public class PageSlideViewModel<T : SlideLifeCycleObject> : SlideLifeCycleObjectProvidable {
    fileprivate var _object : T?
    
    public init() {
        
    }
    
    public init(object : T) {
        _object = object
    }
    
    //MARK: - ScrollLifeCycleObjectGeneratableImplementation
    
    public var lifeCycleObject : SlideLifeCycleObject { get {return buildObjectIfNeeded() } }
}

private typealias PrivatePageSlideViewModel = PageSlideViewModel
extension PrivatePageSlideViewModel  {
    func buildObjectIfNeeded() -> SlideLifeCycleObject {
        if let object = _object {
            return object
        }
        _object = T()
        return _object!
    }
}
