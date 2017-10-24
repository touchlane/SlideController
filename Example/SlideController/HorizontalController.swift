//
//  HorizontalController.swift
//  SlideController_Example
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class HorizontalController {
    private let internalView = HorizontalView()
    private let slideController: SlideController<HorizontalTitleScrollView, HorizontalTitleItem>!
    
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
    
    lazy var changePositionAction: ((Int) -> ())? = { [weak self] position in
        guard let strongSelf = self else { return }
        switch position {
        case 0:
            strongSelf.slideController.titleView.position = TitleViewPosition.beside
            strongSelf.slideController.titleView.isTransparent = false
        case 1:
            strongSelf.slideController.titleView.position = TitleViewPosition.above
            strongSelf.slideController.titleView.isTransparent = true
        default:
            break
        }
    }
}

private typealias ViewLifeCycleDependableImplementation = HorizontalController
extension ViewLifeCycleDependableImplementation : ViewLifeCycleDependable {
    func viewDidAppear() {
        slideController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        slideController.viewDidDisappear()
    }
}

private typealias ViewAccessibleImplementation = HorizontalController
extension ViewAccessibleImplementation : ViewAccessible {
    var view : UIView {
        return internalView
    }
}




