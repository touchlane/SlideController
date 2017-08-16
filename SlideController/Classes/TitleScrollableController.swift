
//
//  HorizontalTitleController.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/16/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class TitleScrollableController<T, N> : TitleScrollable where T : ViewScrollable, T : UIScrollView, T : TitleConfigurable, N : TitleItemControllableObject, N : UIView, N.Item == T.View {
    
    fileprivate var _isOffsetChangeAllowed = true
    fileprivate var _scrollDirection : ScrollDirection
    fileprivate var _selectedIndex = 0
    
    fileprivate lazy var _didCompleteSelectItemAction : () -> () = { [weak self] in
        guard let `self` = self else { return }
        self._isOffsetChangeAllowed = true
    }
    
    fileprivate lazy var _didSelectTitleItemAction : (Int) -> () = { [weak self] index in
        guard let `self` = self else { return }
        self._isOffsetChangeAllowed = false
        self.jump(index: index, animated : true)
        self.didSelectItemAction?(index, self._didCompleteSelectItemAction)
    }

    var didCompleteTitleLayout : (() -> ())?
    
    var titleView : T {
        return _scrollView
    }
    
    fileprivate var _scrollView = T()
    fileprivate var _controllers = [TitleItemController<N>]()
    
    //MARK: - TitleScrollable_Implementation
    
    required init(pagesCount: Int, scrollDirection : ScrollDirection) {
        _scrollDirection = scrollDirection
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    var didSelectItemAction : ((Int, (() -> ())?) -> ())?
    
    func append(pagesCount : Int) {
        var newControllers = [TitleItemController<N>]()
        for index in 0..<pagesCount {
            let controller = TitleItemController<N>()
            controller.index = _controllers.count + index
            controller.didSelectAction = _didSelectTitleItemAction
            newControllers.append(controller)
        }
        _controllers.append(contentsOf: newControllers)
        _scrollView.appendViews(views: newControllers.map{$0.view})
    }
    
    func insert(object : PageScrollViewModel, index : Int) {
        let controller = TitleItemController<N>()
        controller.index = index
        controller.didSelectAction = _didSelectTitleItemAction
        for i in index..<_controllers.count {
            _controllers[i].index = i + 1
        }
        _controllers.insert(controller, at: index)
        _scrollView.insertView(view: controller.view, index: index)
    }
    
    func removeAtIndex(index : Int) {
        for i in index + 1..<_controllers.count {
            _controllers[i].index = i - 1
        }
        _controllers.remove(at: index)
        _scrollView.removeViewAtIndex(index: index)
    }
    
    func jump(index : Int, animated : Bool) {
        if isIndexValid(index) {
            _controllers[_selectedIndex].isSelected = false
            _selectedIndex = index
            _controllers[index].isSelected = true
            // TODO : calculate offset for vertical scroll direction
            switch _scrollDirection {
            case .Horizontal:
                _scrollView.setContentOffset(CGPoint(x: calculateTargetOffset(index), y: 0), animated: animated)
            case .Vertical:
                _scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            }
        }
    }
    
    func shift(delta : CGFloat, startIndex : Int, destinationIndex : Int) {
        if _isOffsetChangeAllowed && isIndexValid(startIndex) && isIndexValid(destinationIndex) {
            let targetOffset = calculateTargetOffset(destinationIndex)
            let startOffset = calculateTargetOffset(startIndex)
            let shift = delta * abs(startOffset - targetOffset) / _scrollView.frame.width
            // TODO : calculate offset for vertical scroll direction
            switch _scrollDirection {
            case .Horizontal:
                _scrollView.setContentOffset(CGPoint(x: _scrollView.contentOffset.x + shift, y: 0), animated: false)
            case .Vertical:
                _scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            }
        }
    }
}

//MARK: - Private_TitleScrollableController

private extension TitleScrollableController {
    func isIndexValid(_ index : Int) -> Bool {
        if index >= 0 && index < _controllers.count {
            return true
        }
        return false
    }
    
    func calculateTargetOffset(_ index : Int) -> CGFloat {
        var newOffsetX = _scrollView.contentOffset.x
        if isIndexValid(index) {
            let title = _controllers[index].view
            if _scrollView.frame.width >= _scrollView.contentSize.width {
                newOffsetX = _scrollView.contentSize.width / 2 - _scrollView.frame.width / 2
            } else if title.center.x >= _scrollView.contentSize.width / 2 {
                if _scrollView.contentSize.width - title.center.x > _scrollView.frame.width / 2 {
                    newOffsetX = title.center.x - _scrollView.frame.width / 2
                } else {
                    newOffsetX = _scrollView.contentSize.width - _scrollView.frame.width
                }
            } else if title.center.x > _scrollView.frame.width / 2 {
                newOffsetX = title.center.x - _scrollView.frame.width / 2
            } else {
                newOffsetX = 0
            }
        }
        return newOffsetX
    }
}


