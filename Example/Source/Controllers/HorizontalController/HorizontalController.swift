//
//  HorizontalController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class HorizontalController {
    private let internalView = HorizontalView()
    private let slideController: SlideController<HorizontalTitleScrollView, HorizontalTitleItem>!

    private var addedPagesCount: Int

    lazy var removeCurrentPageAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        guard let currentPageIndex = strongSelf.slideController.content
            .index(where: { strongSelf.slideController.currentModel === $0 }) else {
            return
        }
        strongSelf.slideController.removeAtIndex(index: currentPageIndex)
    }

    lazy var insertAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(object: ColorPageLifeCycleObject())
        guard let index = strongSelf.slideController.content
            .index(where: { strongSelf.slideController.currentModel === $0 }) else {
                return
        }
        strongSelf.slideController.insert(object: page, index: index)
        strongSelf.addedPagesCount += 1

        let titleItems = strongSelf.slideController.titleView.items
        guard titleItems.indices.contains(index) else { return }
        titleItems[index].titleLabel.text = strongSelf.title(for: strongSelf.addedPagesCount)
    }

    lazy var appendAction: (() -> Void)? = { [weak self] in
        guard let strongSelf = self else { return }
        let page = SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(object: ColorPageLifeCycleObject())
        strongSelf.slideController.append(object: [page])
        strongSelf.addedPagesCount += 1

        let titleItems = strongSelf.slideController.titleView.items
        let lastItemIndex = titleItems.count - 1
        titleItems[lastItemIndex].titleLabel.text = strongSelf.title(for: strongSelf.addedPagesCount)
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

    init() {
        let pagesContent = [
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(object: ColorPageLifeCycleObject()),
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>(),
            SlideLifeCycleObjectBuilder<ColorPageLifeCycleObject>()]
        slideController = SlideController(
            pagesContent: pagesContent,
            startPageIndex: 0,
            slideDirection: SlideDirection.horizontal)

        addedPagesCount = pagesContent.count
        for index in 0..<addedPagesCount {
            slideController.titleView.items[index].titleLabel.text = title(for: index + 1)
        }
      
        slideController.titleView.titleSize = 44
        internalView.contentView = slideController.view
    }

    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
            optionsController?.removeDidTapAction = removeCurrentPageAction
            optionsController?.insertDidTapAction = insertAction
            optionsController?.appendDidTapAction = appendAction
            optionsController?.changePositionAction = changePositionAction
        }
    }
}

private typealias PrivateHorizontalController = HorizontalController
private extension PrivateHorizontalController {
    func title(for index: Int) -> String {
       return "page \(index)"
    }
}

private typealias ViewLifeCycleDependableImplementation = HorizontalController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }

    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = HorizontalController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}

private typealias StatusBarAccessibleImplementation = HorizontalController
extension StatusBarAccessibleImplementation: StatusBarAccessible {
    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private typealias TitleAccessibleImplementation = HorizontalController
extension TitleAccessibleImplementation: TitleAccessible {
    var title: String {
        return "Horizontal"
    }
}

private typealias TitleColorableImplementation = HorizontalController
extension TitleColorableImplementation: TitleColorable {
    var titleColor: UIColor {
        return .white
    }
}
