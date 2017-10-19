//
//  VerticalController.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class VerticalController {
    private let internalView = VerticalView()
    private let slideController: SlideController<MainTitleScrollView, MainTitleItem>
    
    init() {
        let pagesContent = [
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>()
        ]
        self.slideController = SlideController(pagesContent: pagesContent, startPageIndex: 0, slideDirection: .vertical)
        for index in 0..<slideController.content.count {
            self.slideController.titleView.items[index].titleLabel.text = String(format: "page %d", index + 1)
        }
        self.internalView.contentView = slideController.view
    }
    
    var optionsController: ViewAccessible? {
        didSet {
            self.internalView.optionsView = optionsController?.view
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = VerticalController
extension ViewLifeCycleDependableImplementation: ViewLifeCycleDependable {
    func viewDidAppear() {
        self.slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        self.slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = VerticalController
extension ViewAccessibleImplementation: ViewAccessible {
    var view: UIView {
        return self.internalView
    }
}
