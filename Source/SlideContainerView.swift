//
//  SlideContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 4/25/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

///Represents container view for one page content
final class SlideContainerView {
    private var internalView: UIView
    private let containerView = UIView()
    
    ///Constraints for internal view, allow to change UI positioning for container view
    var constraints = [NSLayoutConstraint]()
    
    /// - Parameter view: The view to show as content.
    init(view: UIView) {
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            view.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        internalView = view
    }
    
    ///Sets container view frame width or height to 0,
    ///internal view saves frame size to avoid unnecessary layout work
    func hide(direction: SlideDirection) {
        var removeConstraints: [NSLayoutConstraint] = []
        var addConstraints: [NSLayoutConstraint] = []
        
        let layoutAttribute: NSLayoutAttribute
        let containerViewAnchor: NSLayoutDimension
        let internalViewAnchor: NSLayoutDimension
        let constraintConstant: CGFloat
        switch direction {
        case .horizontal:
            layoutAttribute = .width
            containerViewAnchor = containerView.widthAnchor
            internalViewAnchor = internalView.widthAnchor
            constraintConstant = containerView.frame.size.width
        case .vertical:
            layoutAttribute = .height
            containerViewAnchor = containerView.heightAnchor
            internalViewAnchor = internalView.heightAnchor
            constraintConstant = containerView.frame.size.height
        }
        
        guard let constraintIndex = constraints.index(where: { $0.firstAttribute == layoutAttribute }),
            let viewConstraintIndex = containerView.constraints.index(where: { $0.firstAttribute == layoutAttribute }) else {
            return
        }
        removeConstraints.append(constraints[constraintIndex])
        constraints.remove(at: constraintIndex)
        let constraint = containerViewAnchor.constraint(equalToConstant: 0)
        addConstraints.append(constraint)
        constraints.append(constraint)
        
        removeConstraints.append(containerView.constraints[viewConstraintIndex])
        let viewConstraint = internalViewAnchor.constraint(equalToConstant: constraintConstant)
        addConstraints.append(viewConstraint)
        NSLayoutConstraint.deactivate(removeConstraints)
        NSLayoutConstraint.activate(addConstraints)
    }
    
    ///Returns container view frame width or height to match superview frame
    func show(direction: SlideDirection) {
        guard let superView = containerView.superview else {
            return
        }
        var removeConstraints: [NSLayoutConstraint] = []
        var addConstraints: [NSLayoutConstraint] = []
        
        let layoutAttribute: NSLayoutAttribute
        let containerViewAnchor: NSLayoutDimension
        let internalViewAnchor: NSLayoutDimension
        let superviewAnchor: NSLayoutDimension
        switch direction {
        case .horizontal:
            layoutAttribute = .width
            containerViewAnchor = containerView.widthAnchor
            internalViewAnchor = internalView.widthAnchor
            superviewAnchor = superView.widthAnchor
        case .vertical:
            layoutAttribute = .height
            containerViewAnchor = containerView.heightAnchor
            internalViewAnchor = internalView.heightAnchor
            superviewAnchor = superView.heightAnchor
        }
        
        guard let constraintIndex = constraints.index(where: { $0.firstAttribute == layoutAttribute }),
            let viewConstraintIndex = internalView.constraints.index(where: { $0.firstAttribute == layoutAttribute }) else {
            return
        }
        removeConstraints.append(constraints[constraintIndex])
        constraints.remove(at: constraintIndex)
        let constraint = containerViewAnchor.constraint(equalTo: superviewAnchor)
        addConstraints.append(constraint)
        constraints.append(constraint)
        
        removeConstraints.append(internalView.constraints[viewConstraintIndex])
        let viewConstraint = internalViewAnchor.constraint(equalTo: containerViewAnchor)
        addConstraints.append(viewConstraint)
        NSLayoutConstraint.deactivate(removeConstraints)
        NSLayoutConstraint.activate(addConstraints)
    }
}

///Viewable protocol implementation
private typealias ViewableImplementation = SlideContainerView
extension ViewableImplementation: Viewable {
    var view: UIView {
        return containerView
    }
}
