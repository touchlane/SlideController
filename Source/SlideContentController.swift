//
//  SlideContentController.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/24/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

internal typealias EdgeContainers = (left: SlideContainerController, right: SlideContainerController)

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
    
    ///Left and right temp containers to support infinite scrolling
    internal private(set) var edgeContainers: EdgeContainers?
    
    ///Enables infinite circular scrolling
    internal var isCarousel = false {
        didSet {
            if isCarousel {
                addEdgeContainersIfNeeded()
            }
            else {
                removeEdgeContainersIfNeeded()
            }
        }
    }
    
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
        
        if edgeContainers != nil {
            var index = containers.count - newControllers.count + 1
            for newController in newControllers {
                slideContentView.insertView(view: newController.view, index: index)
                index += 1
            }
        }
        else {
            slideContentView.appendViews(views: newControllers.map { $0.view })
            if isCarousel {
                addEdgeContainersIfNeeded()
            }
        }
    }
    
    ///Insert container at specified index
    func insert(index: Int) {
        let controller = SlideContainerController()
        containers.insert(controller, at: index)
        if edgeContainers != nil {
            slideContentView.insertView(view: controller.view, index: index + 1)
        }
        else {
            slideContentView.insertView(view: controller.view, index: index)
            if isCarousel {
                addEdgeContainersIfNeeded()
            }
        }
    }
    
    ///Remove container at specified index
    func removeAtIndex(index: Int) {
        containers.remove(at: index)
        if edgeContainers != nil {
            slideContentView.removeViewAtIndex(index: index + 1)
            removeEdgeContainersIfNeeded()
        }
        else {
            slideContentView.removeViewAtIndex(index: index)
        }
    }
    
    ///Scroll to target container
    func scroll(fromPage currentIndex: Int, toPage index: Int, animated: Bool) -> (() -> Void)? {
        guard containers.indices.contains(index) else {
            return nil
        }
        let offsetCorrection = edgeContainers == nil ? 0 : contentSize
        var offsetPoint: CGPoint
        var startOffsetPoint = slideContentView.contentOffset
        var endOffsetPoint: CGPoint
        if slideDirection == .horizontal {
            if index < currentIndex {
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index) + offsetCorrection, y: 0)
                startOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index + 1) + offsetCorrection, y: 0)
                endOffsetPoint = offsetPoint
            } else if index == currentIndex{
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: currentIndex) + offsetCorrection, y: 0)
                endOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index) + offsetCorrection, y: 0)
            } else {
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: currentIndex + 1) + offsetCorrection, y: 0)
                endOffsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index) + offsetCorrection, y: 0)
            }
        } else {
            if index < currentIndex {
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index) + offsetCorrection)
                startOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index + 1) + offsetCorrection)
                endOffsetPoint = offsetPoint
            } else if index == currentIndex{
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: currentIndex) + offsetCorrection)
                endOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index) + offsetCorrection)
            } else {
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: currentIndex + 1) + offsetCorrection)
                endOffsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index) + offsetCorrection)
            }
        }
        let indexCorrection = edgeContainers == nil ? 0 : 1
        var viewIndices: [Int] = []
        if currentIndex - index > 1 {
            for i in index + 1...currentIndex - 1 {
                viewIndices.append(i + indexCorrection)
            }
        } else if index - currentIndex > 1 {
            for i in currentIndex + 1...index - 1 {
                viewIndices.append(i + indexCorrection)
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
    
    private func addEdgeContainersIfNeeded() {
        guard edgeContainers == nil && containers.count > 1 else {
            return
        }
        edgeContainers = (left: SlideContainerController(), right: SlideContainerController())
        slideContentView.insertView(view: edgeContainers!.left.view, index: 0)
        slideContentView.appendViews(views: [edgeContainers!.right.view])
    }
    
    private func removeEdgeContainersIfNeeded() {
        guard edgeContainers != nil && containers.count <= 1 else {
            return
        }
        edgeContainers = nil
        slideContentView.removeViewAtIndex(index: 0)
        slideContentView.removeViewAtIndex(index: containers.count)
    }
}
