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
    
    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            
            optionsController?.removeDidTapAction = removePage
            optionsController?.insertDidTapAction = insertPage
            optionsController?.appendDidTapAction = appendPage
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
        let index = slideController.content.count == 0 ? 0 : slideController.content.count - 1
        slideController.insert(object: page, index: index)
    }
    
    func appendPage() {
        let page = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        slideController.append(object: [page])
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
