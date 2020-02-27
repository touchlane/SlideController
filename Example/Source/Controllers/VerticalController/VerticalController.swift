//
//  VerticalController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import SlideController
import UIKit

class VerticalController {
    private let titleSize: CGFloat = 22.5
    private let internalView = VerticalView()
    private let slideController: SlideController<VerticalTitleScrollView, VerticalTitleItem>

    private lazy var removeAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        guard let index = strongSelf.slideController.content
            .firstIndex(where: { strongSelf.slideController.currentModel === $0 }) else {
            return
        }
        strongSelf.slideController.removeAtIndex(index: index)
    }

    private lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>()
        guard let index = strongSelf.slideController.content
            .firstIndex(where: { strongSelf.slideController.currentModel === $0 }) else {
            return
        }
        strongSelf.slideController.insert(object: page, index: index)
    }

    private lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>()
        strongSelf.slideController.append(object: [page])
    }

    private lazy var changePositionAction: ((Int) -> Void)? = { [weak self] position in
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

    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            optionsController?.removeDidTapAction = removeAction
            optionsController?.insertDidTapAction = insertAction
            optionsController?.appendDidTapAction = appendAction
            optionsController?.changePositionAction = changePositionAction
        }
    }

    init() {
        let pagesContent = [
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(),
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(),
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>()
        ]
        slideController = SlideController(pagesContent: pagesContent, startPageIndex: 0, slideDirection: .vertical)
        slideController.titleView.position = .above
        slideController.titleView.alignment = .left
        slideController.titleView.titleSize = titleSize
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

private typealias StatusBarAccessibleImplementation = VerticalController
extension StatusBarAccessibleImplementation: StatusBarAccessible {
    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private typealias TitleAccessibleImplementation = VerticalController
extension TitleAccessibleImplementation: TitleAccessible {
    var title: String {
        return "Vertical"
    }
}

private typealias TitleColorableImplementation = VerticalController
extension TitleColorableImplementation: TitleColorable {
    var titleColor: UIColor {
        return .white
    }
}
