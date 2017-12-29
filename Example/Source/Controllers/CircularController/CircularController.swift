//
//  CircularController.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class CircularController {
    private let internalView = CircularView()
    private let slideController: SlideController<CircularTitleScrollView, CircularTitleItem>!
    
    init() {
        var pagesContent: [SlideLifeCycleObjectBuilder<ImagePageLifeCycleObject>] = []
        for index in 1...5 {
            let page = ImagePageLifeCycleObject()
            page.controller.image = UIImage(named: "image\(index)")
            pagesContent.append(SlideLifeCycleObjectBuilder(object: page))
        }
        slideController = SlideController(
            pagesContent: pagesContent,
            startPageIndex: 0,
            slideDirection: SlideDirection.horizontal)
        slideController.titleView.alignment = .bottom
        slideController.titleView.titleSize = 40
        slideController.isCircular = true
        slideController.titleView.position = .above
        slideController.titleView.isTransparent = true
        internalView.contentView = slideController.view
    }
    
    var optionsController: (ViewAccessible & ContentActionable)? {
        didSet {
            internalView.optionsView = optionsController?.view
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = CircularController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = CircularController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}

private typealias StatusBarAccessibleImplementation = CircularController
extension StatusBarAccessibleImplementation: StatusBarAccessible {
    var statusBarStyle: UIStatusBarStyle {
        return .default
    }
}
