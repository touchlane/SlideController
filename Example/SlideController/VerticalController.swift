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
    
    private lazy var removeAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.slideController.removeAtIndex(index: 0)
    }
    
    private lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlidePageModel<PageLifeCycleObject>()
        let index = strongSelf.slideController.content.count == 0 ? 0 : strongSelf.slideController.content.count - 1
        strongSelf.slideController.insert(object: page, index: index)
    }
    
    private lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlidePageModel<PageLifeCycleObject>()
        strongSelf.slideController.append(object: [page])
    }
    
    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            optionsController?.removeDidTapAction = removeAction
            optionsController?.insertDidTapAction = insertAction
            optionsController?.appendDidTapAction = appendAction
        }
    }
    
    init() {
        let pagesContent = [
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>()
        ]
        slideController = SlideController(pagesContent: pagesContent, startPageIndex: 0, slideDirection: .vertical)
        slideController.titleView.position = .above
        slideController.titleView.alignment = .left
        internalView.contentView = slideController.view
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
