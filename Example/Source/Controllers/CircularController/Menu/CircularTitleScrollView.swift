//
//  CircularTitleScrollView.swift
//  Example
//
//  Created by Vadim Morozov on 12/27/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class CircularTitleScrollView: TitleScrollView<CircularTitleItem> {
    private var internalItems: [View] = []
    
    private let internalItemOffsetX: CGFloat = 0
    private let itemOffsetTop: CGFloat = 10
    private let itemHeight: CGFloat = 20
    private let internalBackgroundColor = UIColor.purple
    
    override required init() {
        super.init()
        backgroundColor = internalBackgroundColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var items: [TitleItem] {
        return internalItems
    }
    
    override func appendViews(views: [View]) {
        var prevView: View? = internalItems.last
        let prevPrevView: UIView? = internalItems.count > 1 ? internalItems[items.count - 2] : nil
        if let prevItem = prevView {
            updateConstraints(view: prevItem, prevView: prevPrevView, isLast: false)
        }
        for i in 0...views.count - 1 {
            let view = views[i]
            view.translatesAutoresizingMaskIntoConstraints = false
            internalItems.append(view)
            addSubview(view)
            activateConstraints(view: view, prevView: prevView, isLast: i == views.count - 1)
            prevView = view
        }
    }
    
    override func insertView(view: View, index: Int) {
        guard index < internalItems.count else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        internalItems.insert(view, at: index)
        addSubview(view)
        let prevView: View? = index > 0 ? internalItems[index - 1] :  nil
        let nextView: View = internalItems[index + 1]
        activateConstraints(view: view, prevView: prevView, isLast: false)
        updateConstraints(view: nextView, prevView: view, isLast: index == internalItems.count - 2)
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
        if let nextView = nextView {
            updateConstraints(view: nextView, prevView: prevView, isLast: index == internalItems.count - 1)
        } else if let prevView = prevView {
            let prevPrevView: View? = internalItems.count > 1 ? internalItems[internalItems.count - 2] : nil
            updateConstraints(view: prevView, prevView: prevPrevView, isLast: true)
        }
    }
    
    var isTransparent = false {
        didSet {
            backgroundColor = isTransparent ? UIColor.clear : internalBackgroundColor
        }
    }
}

private typealias PrivateCircularTitleScrollView = CircularTitleScrollView
private extension PrivateCircularTitleScrollView {
    func activateBackgroundViewConstraints(view: UIView, position: CGFloat, width: CGFloat) {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(view.topAnchor.constraint(equalTo: topAnchor, constant: itemOffsetTop + itemHeight))
        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: position)
        constraints.append(leading)
        let width = view.widthAnchor.constraint(equalToConstant: width)
        constraints.append(width)
        NSLayoutConstraint.activate(constraints)
    }
    
    func activateConstraints(view: UIView, prevView: UIView?, isLast: Bool) {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(view.topAnchor.constraint(equalTo: topAnchor, constant: itemOffsetTop))
        constraints.append(view.heightAnchor.constraint(equalToConstant: itemHeight))
        if let prevView = prevView {
            constraints.append(view.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: 2 * internalItemOffsetX))
        } else {
            constraints.append(view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: internalItemOffsetX))
        }
        if isLast {
            constraints.append(view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -internalItemOffsetX))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func removeConstraints(view: UIView) {
        let viewConstraints = constraints.filter({ $0.firstItem === view })
        let heigthConstraints = view.constraints.filter({ $0.firstAttribute == .height })
        NSLayoutConstraint.deactivate(viewConstraints + heigthConstraints)
    }
    
    func updateConstraints(view: UIView, prevView: UIView?, isLast: Bool) {
        self.removeConstraints(view: view)
        self.activateConstraints(view: view, prevView: prevView, isLast: isLast)
    }
}
