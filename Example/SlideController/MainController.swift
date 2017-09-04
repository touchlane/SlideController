//
//  MainController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import SlideController

///Main controller which can handle pages inseting and removing buisness logic.
class MainController {
    
    fileprivate let containerView = MainView()
    fileprivate let scrollController : ScrollController<MainTitleScrollView, MainTitleItem>!
    
    fileprivate let page1 = Page1LifeCycleObject()
    fileprivate let page2 = Page2LifeCycleObject()
    fileprivate let page3 = Page3LifeCycleObject()
    
    init() {
        let pagesContent = [
            PageScrollViewModel(object: page1),
            PageScrollViewModel(object: page2),
            PageScrollViewModel(object: page3)]
        scrollController = ScrollController(pagesContent : pagesContent, startPageIndex: 0, scrollDirection: ScrollDirection.Horizontal)
        scrollController.titleView.items[0].titleLabel.text = "Color Page 1"
        scrollController.titleView.items[1].titleLabel.text = "Color Page 2"
        scrollController.titleView.items[2].titleLabel.text = "Color Page 3"
        
        containerView.contentView = scrollController.view
    }
    
    var bottomController : Viewable? {
        didSet {
           containerView.bottomView = bottomController?.view
        }
    }
}

private typealias ViewLifeCycleDependable_Implementation = MainController
extension ViewLifeCycleDependable_Implementation : ViewLifeCycleDependable {
    
    func viewDidAppear() {
        scrollController.viewDidAppear()
    }
    
    func viewDidDisappear() {
        scrollController.viewDidDisappear()
    }
}

private typealias Viewable_Implementation = MainController
extension Viewable_Implementation : Viewable {
    
    var view : UIView {
        return containerView
    }
}
