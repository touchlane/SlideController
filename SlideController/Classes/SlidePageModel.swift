//
//  PageScrollViewModel.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

public protocol SlideLifeCycleObjectProvidable : class {
    var lifeCycleObject: SlideLifeCycleObject { get }
}

public class SlidePageModel<T : SlideLifeCycleObject> : SlideLifeCycleObjectProvidable {
    ///Internal LifeCycle Object
    private var object: T?
    
    public init() {
        
    }
    
    ///Use to create model with prebuilt LifeCycle object
    public init(object: T) {
        self.object = object
    }
    
    // MARK: - SlideLifeCycleObjectProvidableImplementation
    public var lifeCycleObject: SlideLifeCycleObject { get { return buildObjectIfNeeded() } }
}

private typealias PrivateSlidePageModel = SlidePageModel
extension PrivateSlidePageModel  {
    ///Genarate LifeCycle object of specified type when needed
    func buildObjectIfNeeded() -> SlideLifeCycleObject {
        if let object = object {
            return object
        }
        object = T()
        return object!
    }
}
