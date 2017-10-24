//
//  HorizontalTitleScrollView.swift
//  SlideController_Example
//
//  Created by Vadim Morozov on 4/20/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit
import SlideController

class HorizontalTitleScrollView : TitleScrollView<HorizontalTitleItem> {
    private var internalItems = [View]()
    private var internalConstraints = [NSLayoutConstraint]()
    private let internalItemOffsetX: CGFloat = 15
    private let itemOffsetTop: CGFloat = 36
    private let itemHeight: CGFloat = 36
    private let shadowOpacity: Float = 0.16
    private let internalBackgroundColor = UIColor(red: 80.0/255.0, green: 44.0/255.0, blue: 146.0/255.0, alpha: 1.0)
    
    override required init() {
        super.init()
        self.isScrollEnabled = false
        self.clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = shadowOpacity
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
            updateConstraints(prevItem, prevView: prevPrevView, isLast: false)
        }
        for i in 0...views.count - 1 {
            let view = views[i]
            view.cornerRadius = itemHeight / 2
            view.translatesAutoresizingMaskIntoConstraints = false
            internalItems.append(view)
            addSubview(view)
            activateConstraints(view, prevView: prevView, isLast: i == views.count - 1)
            prevView = view
        }
    }
    
    override func insertView(view: View, index: Int) {
        guard index < internalItems.count else { return }
        view.cornerRadius = itemHeight / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        internalItems.insert(view, at: index)
        addSubview(view)
        let prevView: View? = index > 0 ? internalItems[index - 1] :  nil
        let nextView: View = internalItems[index + 1]
        activateConstraints(view, prevView: prevView, isLast: false)
        updateConstraints(nextView, prevView: view, isLast: index == internalItems.count - 2)
    }
    
    override func removeViewAtIndex(index: Int) {
        guard index < internalItems.count else { return }
        let view: View = internalItems[index]
        let prevView: View? = index > 0 ? internalItems[index - 1] : nil
        let nextView: View? = index < internalItems.count - 1 ? internalItems[index + 1] : nil
        internalItems.remove(at: index)
        view.removeFromSuperview()
        if let nextView = nextView {
            updateConstraints(nextView, prevView: prevView, isLast: index == internalItems.count - 1)
        } else if let prevView = prevView {
            let prevPrevView: View? = internalItems.count > 1 ? internalItems[internalItems.count - 2] : nil
            updateConstraints(prevView, prevView: prevPrevView, isLast: true)
        }
    }
    
    var isTransparent = false {
        didSet {
            backgroundColor = isTransparent ? UIColor.clear : internalBackgroundColor
        }
    }
}

private typealias PrivateHorizontalTitleScrollView = HorizontalTitleScrollView
private extension PrivateHorizontalTitleScrollView {
    func activateConstraints(_ view: UIView, prevView: UIView?, isLast: Bool) {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.topAnchor.constraint(equalTo: self.topAnchor, constant: itemOffsetTop))
        constraints.append(view.heightAnchor.constraint(equalToConstant: itemHeight))
        if let prevView = prevView {
            constraints.append(view.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: 2 * itemOffsetX()))
        } else {
            constraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: itemOffsetX()))
        }
        if isLast {
            constraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -itemOffsetX()))
        }
        NSLayoutConstraint.activate(constraints)
        internalConstraints.append(contentsOf: constraints)
    }
    
    func updateConstraints(_ view: UIView, prevView: UIView?, isLast: Bool) {
        for constraint in internalConstraints {
            constraint.isActive = false
        }
        internalConstraints.removeAll()
        activateConstraints(view, prevView: prevView, isLast: isLast)
    }
    
    func itemOffsetX() -> CGFloat {
        return internalItemOffsetX
    }
}
