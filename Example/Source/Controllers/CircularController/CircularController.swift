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
        strongSelf.updateTitles()
    }
    
    lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<PageLifeCycleObject>(object: PageLifeCycleObject())
        let index = strongSelf.slideController.content.count == 0 ? 0 : strongSelf.slideController.content.count - 1
        strongSelf.slideController.insert(object: page, index: index)
        strongSelf.updateTitles()
    }
    
    lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<PageLifeCycleObject>(object: PageLifeCycleObject())
        strongSelf.slideController.append(object: [page])
        strongSelf.updateTitles()
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
        updateTitles()
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

private typealias PrivateCircularController = CircularController
private extension PrivateCircularController {
    func updateTitles() {
        for index in 0..<slideController.content.count {
            slideController.titleView.items[index].titleLabel.text = "page \(index + 1)"
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
