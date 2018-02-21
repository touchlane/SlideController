//
//  CarouselController.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class CarouselController {
    private let internalView = CarouselView()
    private let slideController: SlideController<CarouselTitleScrollView, CarouselTitleItem>!
    
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
        slideController.isCarousel = true
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

private typealias ViewLifeCycleDependableImplementation = CarouselController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = CarouselController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return internalView
    }
}

private typealias StatusBarAccessibleImplementation = CarouselController
extension StatusBarAccessibleImplementation: StatusBarAccessible {
    var statusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private typealias TitleAccessibleImplementation = CarouselController
extension TitleAccessibleImplementation: TitleAccessible {
    var title: String {
        return "Carousel"
    }
}

private typealias TitleColorableImplementation = CarouselController
extension TitleColorableImplementation: TitleColorable {
    var titleColor: UIColor {
        return .white
    }
}
