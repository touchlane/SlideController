//
//  PageScrollViewModel.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import Foundation

public protocol SlideLifeCycleObjectProvidable : class {
    var lifeCycleObject: SlideLifeCycleObject { get }
}

public class SlidePageModel<T : SlideLifeCycleObject> : SlideLifeCycleObjectProvidable {
    fileprivate var object: T?
    
    public init() {
        
    }
    
    public init(object: T) {
        self.object = object
    }
    
    //MARK: - ScrollLifeCycleObjectGeneratableImplementation
    
    public var lifeCycleObject: SlideLifeCycleObject { get {return buildObjectIfNeeded() } }
}

private typealias PrivateSlidePageModel = SlidePageModel
extension PrivateSlidePageModel  {
    func buildObjectIfNeeded() -> SlideLifeCycleObject {
        if let object = object {
            return object
        }
        object = T()
        return object!
    }
}
