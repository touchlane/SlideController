//
//  MainController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

// TODO: remove after merging of verticalSlide branch
protocol ContentActionable {
    typealias Action = () -> Void
    
    var removeDidTapAction: Action? { get set }
    var insertDidTapAction: Action? { get set }
    var appendDidTapAction: Action? { get set }
    var menuDidTapAction: Action? { get set }
}

class MainController {
    private let internalView = MainView()
    private let slideController: SlideController<MainTitleScrollView, MainTitleItem>!
    
    init() {
        let pagesContent = [
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>()]
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
        }
    }
    
    lazy var changePositionAction: ((Int) -> Void)? = { [weak self] position in
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
    
    lazy var removeAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.slideController.removeAtIndex(index: 0)
        strongSelf.updateTitles()
    }
    
    lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        let index = strongSelf.slideController.content.count == 0 ? 0 : strongSelf.slideController.content.count - 1
        strongSelf.slideController.insert(object: page, index: index)
        strongSelf.updateTitles()
    }
    
    lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject())
        strongSelf.slideController.append(object: [page])
        strongSelf.updateTitles()
    }
}

private typealias PrivateMainController = MainController
private extension PrivateMainController {
    func updateTitles() {
        for index in 0..<slideController.content.count {
            slideController.titleView.items[index].titleLabel.text = "page \(index + 1)"
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = MainController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = MainController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}
