//
//  MainController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

class MainController {
    private let internalView = MainView()
    private let slideController: SlideController<MainTitleScrollView, MainTitleItem>!
    
    init() {
        let pagesContent = [
            SlidePageModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            SlidePageModel<PageLifeCycleObject>(),
            SlidePageModel<PageLifeCycleObject>()]
        slideController = SlideController(pagesContent: pagesContent, startPageIndex: 0, slideDirection: SlideDirection.horizontal)
        for index in 0..<slideController.content.count {
            slideController.titleView.items[index].titleLabel.text = String(format: "page %d", index + 1)
        }
        internalView.contentView = slideController.view
    }
    
    var optionsController: ViewAccessible? {
        didSet {
           internalView.optionsView = optionsController?.view
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = MainController
extension ViewLifeCycleDependableImplementation : ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = MainController
extension ViewAccessibleImplementation : ViewAccessible {
    var view : UIView {
        return internalView
    }
}




