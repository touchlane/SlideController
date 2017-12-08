//
//  SlideContentController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

///SlideContentController do control for SlideContentView,
///manage container controllers and mount target content when needed
final class SlideContentController {
    private var slideDirection: SlideDirection!
    
    ///Depend on set SlideDirection contentSize indicate width or height of the SlideContentView
    var contentSize: CGFloat = 0
    
    ///Container controllers
    internal private(set) var containers = [SlideContainerController]()
    
    ///Superview for container views
    internal private(set) var slideContentView: SlideContentView
    
    /// - Parameter pagesCount: number of pages
    /// - Parameter scrollDirection: indicates the target slide direction
    init(pagesCount: Int, slideDirection: SlideDirection) {
        self.slideDirection = slideDirection
        slideContentView = SlideContentView(slideDirection: slideDirection)
        if pagesCount > 0 {
            append(pagesCount: pagesCount)
        }
    }
    
    ///Append specified number of containers
    ///- Parameter pagesCount: number of containers to be added
    func append(pagesCount: Int) {
        var newControllers = [SlideContainerController]()
        for _ in 0..<pagesCount {
            let controller = SlideContainerController()
            newControllers.append(controller)
        }
        containers.append(contentsOf: newControllers)
        slideContentView.appendViews(views: newControllers.map { $0.view })
    }
    
    ///Insert container at specified index
    func insert(index: Int) {
        let controller = SlideContainerController()
        containers.insert(controller, at: index)
        slideContentView.insertView(view: controller.view, index: index)
    }
    
    ///Remove container at specified index
    func removeAtIndex(index: Int) {
        containers.remove(at: index)
        slideContentView.removeViewAtIndex(index: index)
    }
    
    ///Scroll to target container
    func scroll(fromPage currentIndex: Int, toPage index: Int, animated: Bool) -> (() -> Void)? {
        guard containers.indices.contains(index) else {
            return nil
        }
        var offsetPoint: CGPoint
        var startOffsetPoint = slideContentView.contentOffset
        var endOffsetPoint: CGPoint
        if slideDirection == .horizontal {
            if index < currentIndex {
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index), y: 0)
                startOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index + 1), y: 0)
                endOffsetPoint = offsetPoint
            } else if index == currentIndex{
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: currentIndex), y: 0)
                endOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index), y: 0)
            } else {
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: currentIndex + 1), y: 0)
                endOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index), y: 0)
            }
        } else {
            if index < currentIndex {
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index))
                startOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index + 1))
                endOffsetPoint = offsetPoint
            } else if index == currentIndex{
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: currentIndex))
                endOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index))
            } else {
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: currentIndex + 1))
                endOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index))
            }
        }
        var viewIndices: [Int] = []
        if currentIndex - index > 1 {
            for i in index + 1...currentIndex - 1 {
                viewIndices.append(i)
            }
        } else if index - currentIndex > 1 {
            for i in currentIndex + 1...index - 1 {
                viewIndices.append(i)
            }
        }
        // Before animation
        slideContentView.hideContainers(at: viewIndices)
        slideContentView.setContentOffset(startOffsetPoint, animated: false)
        // Animation
        slideContentView.setContentOffset(offsetPoint, animated: animated)
        
        let afterAnimation = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            /// Disable scrollView delegate so we won't get scrollViewDidScroll calls
            /// when transition through multiple pages is finished
            let delegate = strongSelf.slideContentView.delegate
            strongSelf.slideContentView.delegate = nil
            strongSelf.slideContentView.showContainers(at: viewIndices)
            strongSelf.slideContentView.setContentOffset(endOffsetPoint, animated: false)
            strongSelf.slideContentView.delegate = delegate
        }
        if animated {
            return afterAnimation
        } else {
            afterAnimation()
        }
        return nil
    }
}
