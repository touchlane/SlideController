//
//  VerticalTitleScrollView.swift
//  SlideController_Example
//
//  Created by Pavel Kondrashkov on 10/17/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class VerticalTitleScrollView: TitleScrollView<VerticalTitleItem> {
    private let itemsViewTopOffset: CGFloat = 20
    private let itemsViewBottomOffset: CGFloat = 20
    private let itemsViewWidth: CGFloat = 22
    private let itemWidth: CGFloat = 2.5
    private let itemHeight: CGFloat = 120
    private let itemHeightMultiplier: CGFloat = 0.67
    private let internalBackgroundColor = UIColor(red: 61 / 255, green: 86 / 255, blue: 166 / 255, alpha: 1)
    private var internalItems: [View] = []
    private let itemsView = UIView()
    
    override required init() {
        super.init()
        backgroundColor = internalBackgroundColor
        isScrollEnabled = false
        itemsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(itemsView)
        activateItemsViewConstraints(view: itemsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var items: [TitleItem] {
        return internalItems
    }
    
    override func appendViews(views: [View]) {
        var prevView: View? = internalItems.last
        internalItems.append(contentsOf: views)
        let heightMultiplier = 1 / CGFloat(internalItems.count)
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            itemsView.addSubview(view)
            activateConstraints(view: view, previousView: prevView, heightMultiplier: heightMultiplier)
            prevView = view
        }
        // Update all view heights
        internalItems.forEach { updateConstraints(view: $0, heightMultiplier: heightMultiplier) }
    }
    
    override func insertView(view: View, index: Int) {
        guard index < internalItems.count else {
            return
        }
        internalItems.insert(view, at: index)
        let prevView: TitleItem? = index > 0 ? internalItems[index - 1] :  nil
        let nextView: TitleItem = internalItems[index + 1]
        let heightMultiplier = 1 / CGFloat(internalItems.count)
        view.translatesAutoresizingMaskIntoConstraints = false
        itemsView.addSubview(view)
        // Activate inserted view constraints
        activateConstraints(view: view, previousView: prevView, heightMultiplier: heightMultiplier)
        if let constraints = nextView.superview?.constraints.filter({ $0.firstItem === nextView}) {
            nextView.superview?.removeConstraints(constraints)
        }
        // Activate next view constraints
        activateConstraints(view: nextView, previousView: view, heightMultiplier: heightMultiplier)
        // Update all view heights
        internalItems.forEach { updateConstraints(view: $0, heightMultiplier: heightMultiplier) }
    }
    
    override func removeViewAtIndex(index: Int) {
        guard index < internalItems.count else {
            return
        }
        let view: View = internalItems[index]
        let prevView: View? = index > 0 ? internalItems[index - 1] : nil
        let nextView: View? = index < internalItems.count - 1 ? internalItems[index + 1] : nil
        internalItems.remove(at: index)
        view.removeFromSuperview()
        let heightMultiplier = 1 / CGFloat(internalItems.count)
        if let nextView = nextView {
            if let constraints = nextView.superview?.constraints.filter({ $0.firstItem === nextView}) {
                nextView.superview?.removeConstraints(constraints)
            }
            activateConstraints(view: nextView, previousView: prevView, heightMultiplier: heightMultiplier)
        }
        internalItems.forEach { updateConstraints(view: $0, heightMultiplier: heightMultiplier) }
    }
    
    var isTransparent = false {
        didSet {
            backgroundColor = isTransparent ? UIColor.clear : internalBackgroundColor
        }
    }
}

private typealias PrivateVerticalTitleScrollView = VerticalTitleScrollView
private extension PrivateVerticalTitleScrollView {
    func activateItemsViewConstraints(view: UIView) {
        guard let superview = view.superview else {
            return
        }
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: itemsViewWidth),
            view.widthAnchor.constraint(equalToConstant: itemsViewWidth),
            view.heightAnchor.constraint(equalTo: superview.heightAnchor, constant: -(itemsViewBottomOffset + itemsViewTopOffset))
            ])
    }
    
    func activateConstraints(view: UIView, previousView: UIView?, heightMultiplier: CGFloat) {
        guard let superview = view.superview else {
            return
        }
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(view.centerXAnchor.constraint(equalTo: superview.centerXAnchor))
        constraints.append(view.widthAnchor.constraint(equalToConstant: itemWidth))
        
        let heightSuperview = view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: heightMultiplier)
        heightSuperview.priority = UILayoutPriority(rawValue: 750)
        constraints.append(heightSuperview)
        
        let heightItem = view.heightAnchor.constraint(lessThanOrEqualToConstant: itemHeight)
        heightItem.priority = UILayoutPriority(rawValue: 1000)
        constraints.append(heightItem)
        
        if let previousView = previousView {
            constraints.append(view.topAnchor.constraint(equalTo: previousView.bottomAnchor))
        } else {
            constraints.append(view.topAnchor.constraint(equalTo: superview.topAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateConstraints(view: UIView, heightMultiplier: CGFloat) {
        guard let superview = view.superview else {
            return
        }
        
        let filterHeightConstraints = itemsView.constraints.filter { constraint in
            let areHeightAttributes = constraint.firstAttribute == .height && constraint.secondAttribute == .height
            let areAppropriateViews = constraint.firstItem === view && constraint.secondItem === itemsView
            return areHeightAttributes && areAppropriateViews
        }
        itemsView.removeConstraints(filterHeightConstraints)
        
        let heightConstraint = view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: heightMultiplier)
        heightConstraint.priority = UILayoutPriority(rawValue: 750)
        heightConstraint.isActive = true
    }
}
