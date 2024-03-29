
//
//  TitleScrollableController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

protocol TitleScrollable: AnyObject {
    var didSelectItemAction: ((Int, (() -> Void)?) -> Void)? { get set }
    func jump(index: Int, animated: Bool)
    func shift(ratio: CGFloat, startIndex: Int, destinationIndex: Int)
    func indicatorSlide(offset: CGFloat, pageSize: CGFloat, startIndex: Int, destinationIndex: Int)
    init(pagesCount: Int, slideDirection: SlideDirection)
}

class TitleSlidableController<T, N>: TitleScrollable where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable, N: TitleItemControllableObject, N: UIView, N.Item == T.View {

    private var isOffsetChangeAllowed = true
    private var slideDirection: SlideDirection
    private var selectedIndex = 0
    
    private lazy var didCompleteSelectItemAction: () -> Void = { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.isOffsetChangeAllowed = true
    }
    
    private lazy var didSelectTitleItemAction: (Int) -> Void = { [weak self] index in
        guard let strongSelf = self else { return }
        guard strongSelf.isSelectionAllowed else {
            return
        }
        if strongSelf.controllers.indices.contains(index) {
            strongSelf.updateSlideIndicator(index: index, slideDirection: strongSelf.slideDirection, animated: strongSelf.titleView.shouldAnimateIndicatorOnSelection(index: index))
        }
        strongSelf.isOffsetChangeAllowed = false
        strongSelf.didSelectItemAction?(index, strongSelf.didCompleteSelectItemAction)
    }

    var didCompleteTitleLayout: (() -> Void)?
    
    var titleView: T {
        return self.scrollView
    }
    
    private var scrollView = T()
    private var controllers: [TitleItemController<N>] = []
    
    var isSelectionAllowed: Bool = true
    
    // MARK: - TitleScrollableImplementation
    required init(pagesCount: Int, slideDirection: SlideDirection) {
        self.slideDirection = slideDirection
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    var didSelectItemAction: ((Int, (() -> Void)?) -> Void)?
    
    func append(pagesCount: Int) {
        var newControllers: [TitleItemController<N>] = []
        for index in 0..<pagesCount {
            let controller = TitleItemController<N>()
            controller.index = controllers.count + index
            controller.didSelectAction = didSelectTitleItemAction
            newControllers.append(controller)
        }
        controllers.append(contentsOf: newControllers)
        scrollView.appendViews(views: newControllers.map({ $0.view }))
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
    
    func indicatorSlide(offset: CGFloat, pageSize: CGFloat, startIndex: Int, destinationIndex: Int) {
        guard controllers.indices.contains(startIndex),
            controllers.indices.contains(destinationIndex) else {
            return
        }
        let multipler = offset / pageSize
        
        var startingPosition: CGFloat = 0
        var destinationPosition: CGFloat = 0
        switch slideDirection {
        case .horizontal:
            startingPosition = controllers[startIndex].view.frame.origin.x
            destinationPosition = controllers[destinationIndex].view.frame.origin.x
        case .vertical:
            startingPosition = controllers[startIndex].view.frame.origin.y
            destinationPosition = controllers[destinationIndex].view.frame.origin.y
        }
        
        let indicatorOffset = startingPosition + multipler * abs(destinationPosition - startingPosition)
        
        var startingSize: CGFloat = 0
        var destinationSize: CGFloat = 0
        switch slideDirection {
        case .horizontal:
            startingSize = controllers[startIndex].view.frame.width
            destinationSize = controllers[destinationIndex].view.frame.width
        case .vertical:
            startingSize = controllers[startIndex].view.frame.height
            destinationSize = controllers[startIndex].view.frame.height
        }
        
        let size = startingSize + abs(multipler) * (destinationSize - startingSize)
 
        titleView.indicator(position: indicatorOffset, size: size, animated: false)
    }
    
    func jump(index: Int, animated: Bool) {
        if controllers.indices.contains(index) {
            select(index: index)
            updateSlideIndicator(index: index, slideDirection: slideDirection, animated: animated && titleView.shouldAnimateIndicatorOnSelection(index: index))
            // TODO: calculate offset for vertical scroll direction
            switch slideDirection {
            case .horizontal:
                let offset = CGPoint(x: calculateTargetOffset(index: index), y: 0)
                scrollView.setContentOffset(offset, animated: animated)
            case .vertical:
                scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            }
        }
    }
    
    func shift(ratio: CGFloat, startIndex: Int, destinationIndex: Int) {
        guard self.isOffsetChangeAllowed, self.controllers.indices.contains(startIndex), self.controllers.indices.contains(destinationIndex) else {
            return
        }

        let targetOffset = calculateTargetOffset(index: destinationIndex)
        let startOffset = calculateTargetOffset(index: startIndex)
        let totalShift = startOffset - targetOffset
        let normalizedRatio = ratio < 0 ? 1 + ratio : ratio
        let shift = normalizedRatio * totalShift
        // TODO: calculate offset for vertical scroll direction
        switch self.slideDirection {
        case .horizontal:
            let offset = CGPoint(x: min(startOffset, targetOffset) + abs(shift), y: 0)
            scrollView.setContentOffset(offset, animated: false)
        case .vertical:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }

    func select(index: Int) {
        guard controllers.indices.contains(index) else {
            return
        }
        if controllers.indices.contains(selectedIndex) {
            controllers[selectedIndex].isSelected = false
        }
        selectedIndex = index
        controllers[index].isSelected = true
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
    
    func updateSlideIndicator(index: Int, slideDirection: SlideDirection, animated: Bool) {
        let frame = self.controllers[index].view.frame
        let position: CGFloat
        let size: CGFloat
        switch slideDirection {
        case .horizontal:
            position = frame.origin.x
            size = frame.width
        case .vertical:
            position = frame.origin.y
            size = frame.height
        }
        
        self.titleView.indicator(position: position, size: size, animated: animated)
    }
}
