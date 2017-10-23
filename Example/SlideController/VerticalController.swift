//
//  VerticalController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class VerticalController {
    private let internalView = VerticalView()
    private let slideController: SlideController<VerticalTitleScrollView, VerticalTitleItem>
    
    var optionsController: (ViewAccessible & VerticalContentControllerActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            
            optionsController?.removeDidTapAction = removePage
            optionsController?.insertDidTapAction = insertPage
        }
    }
    
    init() {
        let pagesContent = [
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        ]
        slideController = SlideController(pagesContent: pagesContent, startPageIndex: 0, slideDirection: .vertical)
        slideController.titleView.position = .above
        slideController.titleView.alignment = .left
        
        internalView.contentView = slideController.view
    }
    
    func removePage() {
        slideController.removeAtIndex(index: 0)
    }
    
    func insertPage() {
        let page = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        slideController.insert(object: page, index: slideController.content.count)
    }
}

private typealias ViewLifeCycleDependableImplementation = VerticalController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = VerticalController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}
