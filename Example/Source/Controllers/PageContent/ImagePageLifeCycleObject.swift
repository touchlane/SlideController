//
//  ImagePageLifeCycleObject.swift
//  Example
//
//  Created by Vadim Morozov on 12/28/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class ImagePageLifeCycleObject: Initializable {
    let controller = ImageController()
    
    // MARK: - InitialazableImplementation
    
    required init() {
        
    }
}

private typealias SlideImagePageLifeCycleImplementation = ImagePageLifeCycleObject
extension SlideImagePageLifeCycleImplementation: SlidePageLifeCycle {
    var isKeyboardResponsive: Bool {
        return false
    }
    
    func didAppear() { }
    
    func didDissapear() { }
    
    func viewDidLoad() { }
    
    func viewDidUnload() { }
    
    func didStartSliding() { }
    
    func didCancelSliding() { }
}

private typealias ViewableImplementation = ImagePageLifeCycleObject
extension ViewableImplementation: Viewable {
    var view: UIView {
        get {
            return controller.view
        }
    }
}
