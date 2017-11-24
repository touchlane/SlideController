//
//  SlideContentView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 3/13/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

final class SlideContentView: UIScrollView {
    private let slideDirection: SlideDirection
    private var containers: [SlideContainerView] = []
    
    ///Simple hack to be notified when layout completed
    var firstLayoutAction: (() -> Void)?
    internal private(set) var isLayouted = false
    
    ///Notifies on each size or content size update
    var changeLayoutAction: (() -> ())?
    private var previousSize = CGSize.zero
    private var previousContentSize = CGSize.zero
    
    /// - Parameter scrollDirection: indicates the target slide direction
    init(slideDirection: SlideDirection) {
        self.slideDirection = slideDirection
        super.init(frame: CGRect.zero)
        isPagingEnabled = true
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isDirectionalLockEnabled = true
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isLayouted {
            isLayouted = true
            firstLayoutAction?()
        }
        if bounds.size != previousSize || contentSize != previousContentSize {
            previousSize = bounds.size
            previousContentSize = contentSize
            changeLayoutAction?()
        }
    }
    
    func hideContainers(at indices: [Int]) {
        let pages = containers
            .enumerated()
            .filter({ indices.contains($0.offset) })
            .map({ $0.element })
        for page in pages {
            page.hide(direction: slideDirection)
        }
    }
    
    func showContainers(at indices: [Int]) {
        let pages = containers
            .enumerated()
            .filter({ indices.contains($0.offset) })
            .map({ $0.element })
        for page in pages {
            page.show(direction: slideDirection)
        }
    }
}

private typealias PrivateContentSlideView = SlideContentView
private extension PrivateContentSlideView {
    ///Set constraints depend target slide direction
    func activateConstraints(page: SlideContainerView, prevPage: SlideContainerView?, isLast: Bool, direction: SlideDirection) {
        page.constraints.append(page.view.widthAnchor.constraint(equalTo: self.widthAnchor))
        page.constraints.append(page.view.heightAnchor.constraint(equalTo: self.heightAnchor))
        if direction == SlideDirection.horizontal {
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
    
    //Update constraints for specific container
    func updateConstraints(page: SlideContainerView, prevPage: SlideContainerView?, isLast: Bool, direction: SlideDirection) {
        for constraint in page.constraints {
            constraint.isActive = false
        }
        page.constraints.removeAll()
        activateConstraints(page: page, prevPage: prevPage, isLast: isLast, direction: direction)
    }
}

private typealias ViewSlidableImplementation = SlideContentView
extension ViewSlidableImplementation: ViewSlidable {
    typealias View = UIView
    
    func appendViews(views: [View]) {
        var prevPage: SlideContainerView? = containers.last
        let prevPrevPage: SlideContainerView? = containers.count > 1 ? containers[containers.count - 2] : nil
        if let prevPage = prevPage {
            updateConstraints(page: prevPage, prevPage: prevPrevPage, isLast: false, direction: slideDirection)
        }
        for i in 0...views.count - 1 {
            let view = views[i]
            view.backgroundColor = UIColor.clear
            view.translatesAutoresizingMaskIntoConstraints = false
            let viewModel = SlideContainerView(view: view)
            containers.append(viewModel)
            addSubview(viewModel.view)
            activateConstraints(page: viewModel, prevPage: prevPage, isLast: i == views.count - 1, direction: slideDirection)
            prevPage = viewModel
        }
    }
    
    func insertView(view: View, index: Int) {
        guard index < containers.count else { return }
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewModel = SlideContainerView(view: view)
        containers.insert(viewModel, at: index)
        addSubview(viewModel.view)
        let prevPage = index > 0 ? containers[index - 1]:  nil
        let nextPage = containers[index + 1]
        activateConstraints(page: viewModel, prevPage: prevPage, isLast: false, direction: slideDirection)
        updateConstraints(page: nextPage, prevPage: viewModel, isLast: index == containers.count - 2, direction: slideDirection)
    }
    
    func removeViewAtIndex(index: Int) {
        guard index < containers.count else { return }
        let page = containers[index]
        let prevPage = index > 0 ? containers[index - 1]: nil
        let nextPage = index < containers.count - 1 ? containers[index + 1]: nil
        containers.remove(at: index)
        page.view.removeFromSuperview()
        if let nextPage = nextPage {
            updateConstraints(page: nextPage, prevPage: prevPage, isLast: index == containers.count - 1, direction: slideDirection)
        } else if let prevPage = prevPage {
            let prevPrevPage = containers.count > 1 ? containers[containers.count - 2]: nil
            updateConstraints(page: prevPage, prevPage: prevPrevPage, isLast: true, direction: slideDirection)
        }
    }
}
