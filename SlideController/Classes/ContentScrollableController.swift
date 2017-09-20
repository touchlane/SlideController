//
//  ContentScrollableController.swift
//  youlive
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ContentScrollableController {
    var pageSize : CGFloat = 0
    var didCompleteContentLayout : (() -> ())?
    
    internal private(set) var controllers = [ContentPageController]()
    internal private(set) var scrollView : ContentScrollView
    
    fileprivate var _scrollDirection : ScrollDirection!
    
    init(pagesCount : Int, scrollDirection : ScrollDirection) {
        _scrollDirection = scrollDirection
        scrollView = ContentScrollView(scrollDirection: scrollDirection)
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    func isContentLoaded(_ index : Int) -> Bool {
        if isIndexValid(index) {
            return controllers[index].isContentLoaded()
        }
        return false
    }
    
    func loadViewIfNeeded(_ view : UIView, index : Int) {
        if isIndexValid(index) {
            controllers[index].loadView(view)
        }
    }
    
    func append(pagesCount : Int) {
        var newControllers = [ContentPageController]()
        for _ in 0..<pagesCount {
            let controller = ContentPageController()
            newControllers.append(controller)
        }
        controllers.append(contentsOf: newControllers)
        scrollView.appendViews(views: newControllers.map{$0.view})
    }
    
    func insert(object : PageScrollViewModel, index : Int) {
        let controller = ContentPageController()
        controllers.insert(controller, at: index)
        scrollView.insertView(view: controller.view, index: index)
    }
    
    func removeAtIndex(index : Int) {
        controllers.remove(at: index)
        scrollView.removeViewAtIndex(index: index)
    }
    
    func scrollToPage(_ index : Int, animated : Bool) {
        if isIndexValid(index) {
            var offsetPoint : CGPoint
            if _scrollDirection == ScrollDirection.Horizontal {
                offsetPoint = CGPoint(x: pageSize * CGFloat(integerLiteral: index), y: 0)
            } else {
                offsetPoint = CGPoint(x: 0, y: pageSize * CGFloat(integerLiteral: index))
            }
            scrollView.setContentOffset(offsetPoint, animated: animated)
        }
    }
}

private typealias Private_ContentScrollableController = ContentScrollableController
private extension Private_ContentScrollableController {
    func isIndexValid(_ index : Int) -> Bool {
        if index >= 0 && index < controllers.count {
            return true
        }
        return false
    }
}


