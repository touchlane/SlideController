//
//  ContentScrollView.swift
//  PageScrollUIViewController
//
//  Created by Evgeny Dedovets on 3/13/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ContentScrollView: UIScrollView {
  
    var firstLayoutAction : (() -> ())?
    
    fileprivate var scrollDirection : ScrollDirection!
    fileprivate var pages = [ContentPage]()
    internal private(set) var isLayouted = false
    
    init(scrollDirection : ScrollDirection) {
        self.scrollDirection = scrollDirection
        super.init(frame: CGRect.zero)
        isPagingEnabled = true
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isDirectionalLockEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayouted {
            isLayouted = true
            firstLayoutAction?()
        }
    }
}

private typealias Private_ContentScrollView = ContentScrollView
private extension Private_ContentScrollView {
    func activateConstraints(_ page : ContentPage, prevPage : ContentPage?, isLast : Bool, direction : ScrollDirection) {
        page.constraints.append(page.view.widthAnchor.constraint(equalTo: self.widthAnchor))
        page.constraints.append(page.view.heightAnchor.constraint(equalTo: self.heightAnchor))
        if direction == ScrollDirection.Horizontal {
            page.constraints.append(page.view.topAnchor.constraint(equalTo: self.topAnchor))
            if let prevPage = prevPage {
                page.constraints.append(page.view.leadingAnchor.constraint(equalTo: prevPage.view.trailingAnchor))
            } else {
                page.constraints.append(page.view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            }
            if isLast {
                page.constraints.append(page.view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            }
        } else {
            page.constraints.append(page.view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            if let prevPage = prevPage {
                page.constraints.append(page.view.topAnchor.constraint(equalTo: prevPage.view.bottomAnchor))
            } else {
                page.constraints.append(page.view.topAnchor.constraint(equalTo: self.topAnchor))
            }
            if isLast {
                page.constraints.append(page.view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            }
        }
        NSLayoutConstraint.activate(page.constraints)
    }
    
    func updateConstraints(_ page : ContentPage, prevPage : ContentPage?, isLast : Bool, direction : ScrollDirection) {
        for constraint in page.constraints {
            constraint.isActive = false
        }
        page.constraints.removeAll()
        activateConstraints(page, prevPage : prevPage, isLast : isLast, direction : direction)
    }
}

private typealias ViewScrollable_Implementation = ContentScrollView
extension ViewScrollable_Implementation : ViewScrollable {
    typealias View = UIView
    
    func appendViews(views: [View]) {
        
        var prevPage : ContentPage? = pages.last
        let prevPrevPage : ContentPage? = pages.count > 1 ? pages[pages.count - 2] : nil
        
        if let prevPage = prevPage {
            updateConstraints(prevPage, prevPage : prevPrevPage, isLast : false, direction: scrollDirection)
        }
        
        for i in 0...views.count - 1 {
            let view = views[i]
            view.backgroundColor = UIColor.clear
            view.translatesAutoresizingMaskIntoConstraints = false
            let viewModel = ContentPage(view: view)
            pages.append(viewModel)
            addSubview(view)
            activateConstraints(viewModel, prevPage: prevPage, isLast: i == views.count - 1, direction: scrollDirection)
            prevPage = viewModel
        }
    }
    
    func insertView(view : View, index : Int) {
        guard index < pages.count else { return }
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewModel = ContentPage(view: view)
        pages.insert(viewModel, at: index)
        addSubview(view)
        let prevPage : ContentPage? = index > 0 ? pages[index - 1] :  nil
        let nextPage : ContentPage = pages[index + 1]
        activateConstraints(viewModel, prevPage: prevPage, isLast: false, direction: scrollDirection)
        updateConstraints(nextPage, prevPage : viewModel, isLast : index == pages.count - 2, direction: scrollDirection)
    }
    
    func removeViewAtIndex(index : Int) {
        guard index < pages.count else { return }
        let page : ContentPage = pages[index]
        let prevPage : ContentPage? = index > 0 ? pages[index - 1] : nil
        let nextPage : ContentPage? = index < pages.count - 1 ? pages[index + 1] : nil
        
        pages.remove(at: index)
        page.view.removeFromSuperview()
        if let nextPage = nextPage {
            updateConstraints(nextPage, prevPage: prevPage, isLast: index == pages.count - 1, direction: scrollDirection)
        } else if let prevPage = prevPage {
            let prevPrevPage : ContentPage? = pages.count > 1 ? pages[pages.count - 2] : nil
            updateConstraints(prevPage, prevPage: prevPrevPage, isLast: true, direction: scrollDirection)
        }
    }
}
