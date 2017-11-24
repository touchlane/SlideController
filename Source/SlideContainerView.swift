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
        switch direction {
        case .horizontal:
            guard let constraintIndex = constraints.index(where: { $0.firstAttribute == .width }) else {
                return
            }
            removeConstraints.append(constraints[constraintIndex])
            constraints.remove(at: constraintIndex)
            let widthConstraint = containerView.widthAnchor.constraint(equalToConstant: 0)
            addConstraints.append(widthConstraint)
            constraints.append(widthConstraint)
            
            guard let viewConstraintIndex = containerView.constraints.index(where: { $0.firstAttribute == .width }) else {
                return
            }
            removeConstraints.append(containerView.constraints[viewConstraintIndex])
            let viewWidthConstraint = internalView.widthAnchor.constraint(equalToConstant: containerView.frame.size.width)
            addConstraints.append(viewWidthConstraint)
        case .vertical:
            guard let constraintIndex = constraints.index(where: { $0.firstAttribute == .height }) else {
                return
            }
            removeConstraints.append(constraints[constraintIndex])
            constraints.remove(at: constraintIndex)
            let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: 0)
            addConstraints.append(heightConstraint)
            constraints.append(heightConstraint)
            
            guard let viewConstraintIndex = containerView.constraints.index(where: { $0.firstAttribute == .height }) else {
                return
            }
            removeConstraints.append(containerView.constraints[viewConstraintIndex])
            let viewHeightConstraint = internalView.heightAnchor.constraint(equalToConstant: containerView.frame.size.height)
            addConstraints.append(viewHeightConstraint)
        }
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
        switch direction {
        case .horizontal:
            guard let constraintIndex = constraints.index(where: { $0.firstAttribute == .width }) else {
                return
            }
            removeConstraints.append(constraints[constraintIndex])
            constraints.remove(at: constraintIndex)
            let widthConstraint = containerView.widthAnchor.constraint(equalTo: superView.widthAnchor)
            addConstraints.append(widthConstraint)
            constraints.append(widthConstraint)
            
            guard let viewConstraintIndex = internalView.constraints.index(where: { $0.firstAttribute == .width }) else {
                return
            }
            removeConstraints.append(internalView.constraints[viewConstraintIndex])
            let viewWidthConstraint = internalView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            addConstraints.append(viewWidthConstraint)
        case .vertical:
            guard let constraintIndex = constraints.index(where: { $0.firstAttribute == .height }) else {
                return
            }
            removeConstraints.append(constraints[constraintIndex])
            constraints.remove(at: constraintIndex)
            let heightConstraint = containerView.heightAnchor.constraint(equalTo: superView.heightAnchor)
            addConstraints.append(heightConstraint)
            constraints.append(heightConstraint)
            
            guard let viewConstraintIndex = internalView.constraints.index(where: { $0.firstAttribute == .height }) else {
                return
            }
            removeConstraints.append(internalView.constraints[viewConstraintIndex])
            let viewHeightConstraint = internalView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            addConstraints.append(viewHeightConstraint)
        }
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
