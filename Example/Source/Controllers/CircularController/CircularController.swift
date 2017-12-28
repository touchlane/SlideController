//
//  CircularController.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class CircularController {
    private let internalView = CircularView()
    private let slideController: SlideController<CircularTitleScrollView, CircularTitleItem>!
    
    lazy var removeAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.slideController.removeAtIndex(index: 0)
    }
    
    lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<PageLifeCycleObject>(object: PageLifeCycleObject())
        let index = strongSelf.slideController.content.count == 0 ? 0 : strongSelf.slideController.content.count - 1
        strongSelf.slideController.insert(object: page, index: index)
    }
    
    lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<PageLifeCycleObject>(object: PageLifeCycleObject())
        strongSelf.slideController.append(object: [page])
    }
    
    private lazy var changePositionAction: ((Int) -> ())? = { [weak self] position in
        guard let strongSelf = self else { return }
        switch position {
        case 0:
            strongSelf.slideController.titleView.position = TitleViewPosition.beside
            strongSelf.slideController.titleView.isTransparent = false
        case 1:
            strongSelf.slideController.titleView.position = TitleViewPosition.above
            strongSelf.slideController.titleView.isTransparent = true
        default:
            break
        }
    }
    
    init() {
        let pagesContent = [
            SlideLifeCycleObjectBuilder<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlideLifeCycleObjectBuilder<PageLifeCycleObject>(),
            SlideLifeCycleObjectBuilder<PageLifeCycleObject>()]
        slideController = SlideController(
            pagesContent: pagesContent,
            startPageIndex: 0,
            slideDirection: SlideDirection.horizontal)
        slideController.titleView.alignment = .bottom
        slideController.titleView.titleSize = 40
        slideController.isCircular = true
        internalView.contentView = slideController.view
    }
    
    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            optionsController?.removeDidTapAction = removeAction
            optionsController?.insertDidTapAction = insertAction
            optionsController?.appendDidTapAction = appendAction
            optionsController?.changePositionAction = changePositionAction
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = CircularController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = CircularController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}
