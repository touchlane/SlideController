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
        slideContentView.appendViews(views: newControllers.map{$0.view})
    }
    
    ///Insert container at specified index
    func insert(index : Int) {
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
    func scrollToPage(index: Int, animated: Bool) {
        if containers.indices.contains(index) {
            var offsetPoint: CGPoint
            if slideDirection == SlideDirection.horizontal {
                offsetPoint = CGPoint(x: contentSize * CGFloat(integerLiteral: index), y: 0)
            } else {
                offsetPoint = CGPoint(x: 0, y: contentSize * CGFloat(integerLiteral: index))
            }
            slideContentView.setContentOffset(offsetPoint, animated: animated)
        }
    }
}
