
//
//  TitleScrollableController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
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
        guard let strongSelf = self else { return }
        strongSelf.isOffsetChangeAllowed = true
    }
    
    private lazy var didSelectTitleItemAction: (Int) -> () = { [weak self] index in
        guard let strongSelf = self else { return }
        strongSelf.isOffsetChangeAllowed = false
        strongSelf.jump(index: index, animated: true)
        strongSelf.didSelectItemAction?(index, strongSelf.didCompleteSelectItemAction)
    }

    var didCompleteTitleLayout: (() -> Void)?
    
    var titleView: T {
        return scrollView
    }
    
    private var scrollView = T()
    private var controllers = [TitleItemController<N>]()
    
    var isJumpingAllowed: Bool = true {
        didSet {
            titleView.isScrollEnabled = isJumpingAllowed
        }
    }
    
    // MARK: - TitleScrollableImplementation
    required init(pagesCount: Int, slideDirection: SlideDirection) {
        self.scrollDirection = slideDirection
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    var didSelectItemAction: ((Int, (() -> Void)?) -> Void)?
    
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
        guard isJumpingAllowed else {
            return
        }
        if controllers.indices.contains(index) {
            if controllers.indices.contains(selectedIndex) {
                controllers[selectedIndex].isSelected = false
            }
            selectedIndex = index
            controllers[index].isSelected = true
            // TODO: calculate offset for vertical scroll direction
            switch scrollDirection {
            case .horizontal:
                scrollView.setContentOffset(CGPoint(x: calculateTargetOffset(index: index), y: 0), animated: animated)
            case .vertical:
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            }
        }
    }
    
    func shift(delta: CGFloat, startIndex: Int, destinationIndex: Int) {
        if isOffsetChangeAllowed && controllers.indices.contains(startIndex) && controllers.indices.contains(destinationIndex) {
            let targetOffset = calculateTargetOffset(index: destinationIndex)
            let startOffset = calculateTargetOffset(index: startIndex)
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

private typealias PrivateTitleSlidableController = TitleSlidableController
private extension PrivateTitleSlidableController {
    func calculateTargetOffset(index: Int) -> CGFloat {
        var newOffsetX = scrollView.contentOffset.x
        if controllers.indices.contains(index) {
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


