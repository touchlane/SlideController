//
//  ContentScrollableController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ContentSlidableController {
    var pageSize: CGFloat = 0
    var didCompleteContentLayout: (() -> ())?
    
    internal private(set) var controllers = [ContentPageController]()
    internal private(set) var scrollView: ContentSlideView
    
    fileprivate var scrollDirection: SlideDirection!
    
    init(pagesCount: Int, scrollDirection: SlideDirection) {
        self.scrollDirection = scrollDirection
        scrollView = ContentSlideView(scrollDirection: scrollDirection)
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    func isContentLoaded(atIndex: Int) -> Bool {
        if isIndexValid(atIndex) {
            return controllers[atIndex].isContentLoaded()
        }
        return false
    }
    
    func loadViewIfNeeded(_ view: UIView, index: Int) {
        if isIndexValid(index) {
            controllers[index].load(childView: view)
        }
    }
    
    func append(pagesCount: Int) {
        var newControllers = [ContentPageController]()
        for _ in 0..<pagesCount {
            let controller = ContentPageController()
            newControllers.append(controller)
        }
        controllers.append(contentsOf: newControllers)
        scrollView.appendViews(views: newControllers.map{$0.view})
    }
    
    func insert(index : Int) {
        let controller = ContentPageController()
        controllers.insert(controller, at: index)
        scrollView.insertView(view: controller.view, index: index)
    }
    
    func removeAtIndex(index: Int) {
        controllers.remove(at: index)
        scrollView.removeViewAtIndex(index: index)
    }
    
    func scrollToPage(_ index: Int, animated: Bool) {
        if isIndexValid(index) {
            var offsetPoint: CGPoint
            if scrollDirection == SlideDirection.Horizontal {
                offsetPoint = CGPoint(x: pageSize * CGFloat(integerLiteral: index), y: 0)
            } else {
                offsetPoint = CGPoint(x: 0, y: pageSize * CGFloat(integerLiteral: index))
            }
            scrollView.setContentOffset(offsetPoint, animated: animated)
        }
    }
}

private typealias PrivateContentSlidableController = ContentSlidableController
private extension PrivateContentSlidableController {
    func isIndexValid(_ index: Int) -> Bool {
        if index >= 0 && index < controllers.count {
            return true
        }
        return false
    }
}


