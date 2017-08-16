//
//  MainController.swift
//  PandaDemo
//
//  Created by Evgeny Dedovets on 8/10/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit
import ScrollController

class MainController {
    
    fileprivate let _view = MainView()
    fileprivate let _scrollControler : ScrollController<MainTitleScrollView, MainTitleItem>!
    
    fileprivate let page1 = Page1LifeCycleObject()
    fileprivate let page2 = Page2LifeCycleObject()
    fileprivate let page3 = Page3LifeCycleObject()
    
    init() {
        let pagesContent = [
            PageScrollViewModel(object: page1),
            PageScrollViewModel(object: page2),
            PageScrollViewModel(object: page3)]
        _scrollControler = ScrollController(pagesContent : pagesContent, startPageIndex: 0, scrollDirection: ScrollDirection.Horizontal)
        _scrollControler.titleView.items[0].titleLabel.text = "Color Page 1"
        _scrollControler.titleView.items[1].titleLabel.text = "Color Page 2"
        _scrollControler.titleView.items[2].titleLabel.text = "Color Page 3"
        
        _view.contentView = _scrollControler.view
    }
    
    var bottomController : Viewable? {
        didSet {
           _view.bottomView = bottomController?.view
        }
    }
}

private typealias ViewLifeCycleDependable_Implementation = MainController
extension ViewLifeCycleDependable_Implementation : ViewLifeCycleDependable {
    
    func viewDidAppear() {
        _scrollControler.viewDidAppear()
    }
    
    func viewDidDisappear() {
        _scrollControler.viewDidDisappear()
    }
}

private typealias Viewable_Implementation = MainController
extension Viewable_Implementation : Viewable {
    
    var view : UIView {
        return _view
    }
}




