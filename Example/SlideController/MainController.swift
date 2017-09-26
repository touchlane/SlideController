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
    fileprivate let _view = MainView()
    fileprivate let _scrollControler : SlideController<MainTitleScrollView, MainTitleItem>!
    
    init() {
        let pagesContent = [
            PageSlideViewModel<PageLifeCycleObject>(object: PageLifeCycleObject()),
            PageSlideViewModel<PageLifeCycleObject>(),
            PageSlideViewModel<PageLifeCycleObject>()]
        _scrollControler = SlideController(pagesContent : pagesContent, startPageIndex: 0, scrollDirection: SlideDirection.Horizontal)
        for index in 0..<_scrollControler.content.count {
            _scrollControler.titleView.items[index].titleLabel.text = String(format: "page %d", index + 1)
        }
        _view.contentView = _scrollControler.view
    }
    
    var optionsController : ViewAccessible? {
        didSet {
           _view.optionsView = optionsController?.view
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
extension Viewable_Implementation : ViewAccessible {
    var view : UIView {
        return _view
    }
}




