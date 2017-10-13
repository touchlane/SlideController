
//
//  TitleScrollableController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

protocol TitleScrollable: class {
    var didSelectItemAction: ((Int, (() -> ())?) -> ())? { get set }
    func jump(index: Int, animated: Bool)
    func shift(delta: CGFloat, startIndex: Int, destinationIndex: Int)
    init(pagesCount: Int, slideDirection: SlideDirection)
}

class TitleSlidableController<T, N>: TitleScrollable where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable, N: TitleItemControllableObject, N: UIView, N.Item == T.View {
    private var isOffsetChangeAllowed = true
    private var scrollDirection: SlideDirection
    private var selectedIndex = 0
    
    private lazy var didCompleteSelectItemAction: () -> () = { [weak self] in
        guard let `self` = self else { return }
        self.isOffsetChangeAllowed = true
    }
    
    private lazy var didSelectTitleItemAction: (Int) -> () = { [weak self] index in
        guard let `self` = self else { return }
        self.isOffsetChangeAllowed = false
        self.jump(index: index, animated: true)
        self.didSelectItemAction?(index, self.didCompleteSelectItemAction)
    }

    var didCompleteTitleLayout: (() -> ())?
    
    var titleView: T {
        return scrollView
    }
    
    private var scrollView = T()
    private var controllers = [TitleItemController<N>]()
    
    //MARK: - TitleScrollableImplementation
    required init(pagesCount: Int, slideDirection: SlideDirection) {
        self.scrollDirection = slideDirection
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    var didSelectItemAction: ((Int, (() -> ())?) -> ())?
    
    func append(pagesCount: Int) {
        var newControllers = [TitleItemController<N>]()
        for index in 0..<pagesCount {
            let controller = TitleItemController<N>()
            controller.index = controllers.count + index
            controller.didSelectAction = didSelectTitleItemAction
            newControllers.append(controller)
        }
        controllers.append(contentsOf: newControllers)
        scrollView.appendViews(views: newControllers.map{$0.view})
    }
    
    func insert(index: Int) {
        let controller = TitleItemController<N>()
        controller.index = index
        controller.didSelectAction = didSelectTitleItemAction
        for i in index..<controllers.count {
            controllers[i].index = i + 1
        }
        controllers.insert(controller, at: index)
        scrollView.insertView(view: controller.view, index: index)
    }
    
    func removeAtIndex(index: Int) {
        for i in index + 1..<controllers.count {
            controllers[i].index = i - 1
        }
        controllers.remove(at: index)
        scrollView.removeViewAtIndex(index: index)
    }
    
    func jump(index: Int, animated: Bool) {
        if isIndexValid(index) {
            controllers[selectedIndex].isSelected = false
            selectedIndex = index
            controllers[index].isSelected = true
            // TODO: calculate offset for vertical scroll direction
            switch scrollDirection {
            case .horizontal:
                scrollView.setContentOffset(CGPoint(x: calculateTargetOffset(index), y: 0), animated: animated)
            case .vertical:
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            }
        }
    }
    
    func shift(delta: CGFloat, startIndex: Int, destinationIndex: Int) {
        if isOffsetChangeAllowed && isIndexValid(startIndex) && isIndexValid(destinationIndex) {
            let targetOffset = calculateTargetOffset(destinationIndex)
            let startOffset = calculateTargetOffset(startIndex)
            let shift = delta * abs(startOffset - targetOffset) / scrollView.frame.width
            // TODO: calculate offset for vertical scroll direction
            switch scrollDirection {
            case .horizontal:
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + shift, y: 0), animated: false)
            case .vertical:
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
    }
}

// MARK: - PrivateTitleScrollableController
private extension TitleSlidableController {
    func isIndexValid(_ index: Int) -> Bool {
        if index >= 0 && index < controllers.count {
            return true
        }
        return false
    }
    
    func calculateTargetOffset(_ index: Int) -> CGFloat {
        var newOffsetX = scrollView.contentOffset.x
        if isIndexValid(index) {
            let title = controllers[index].view
            if scrollView.frame.width >= scrollView.contentSize.width {
                newOffsetX = scrollView.contentSize.width / 2 - scrollView.frame.width / 2
            } else if title.center.x >= scrollView.contentSize.width / 2 {
                if scrollView.contentSize.width - title.center.x > scrollView.frame.width / 2 {
                    newOffsetX = title.center.x - scrollView.frame.width / 2
                } else {
                    newOffsetX = scrollView.contentSize.width - scrollView.frame.width
                }
            } else if title.center.x > scrollView.frame.width / 2 {
                newOffsetX = title.center.x - scrollView.frame.width / 2
            } else {
                newOffsetX = 0
            }
        }
        return newOffsetX
    }
}


