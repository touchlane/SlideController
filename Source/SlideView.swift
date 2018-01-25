//
//  ScrollContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class SlideView<T>: UIView, TitleViewConfigurationDelegate where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable {
    private var contentViewConstraints = [NSLayoutConstraint]()
    private var titleViewConstraints = [NSLayoutConstraint]()
    
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateContentViewConstraints(view: view, titleView: titleView)
            }
        }
    }
    
    var titleView: T? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = titleView {
                view.translatesAutoresizingMaskIntoConstraints = false
                view.titleViewConfigurationDelegate = self
                self.addSubview(view)
                activateTitleViewConstraints(view: view)
                if let contentView = contentView {
                    activateContentViewConstraints(view: contentView, titleView: view)
                }
            }
        }
    }
    
    // MARK: - TitleViewConfigurationDelegateImplementation
    func didChangeAlignment(alignment: TitleViewAlignment) {
        if let contentView = contentView {
            activateContentViewConstraints(view: contentView, titleView: titleView)
        }
        if let titleView = titleView {
            activateTitleViewConstraints(view: titleView)
        }
    }
    
    func didChangeTitleSize(size: CGFloat) {
        if let titleView = titleView {
            activateTitleViewConstraints(view: titleView)
            if let contentView = contentView {
                activateContentViewConstraints(view: contentView, titleView: titleView)
            }
        }
    }
    
    func didChangePosition(position: TitleViewPosition) {
        if let contentView = contentView {
            activateContentViewConstraints(view: contentView, titleView: titleView)
        }
    }
    
}

private typealias PrivateSlideView = SlideView
private extension PrivateSlideView {
    func activateContentViewConstraints(view: UIView, titleView: T?) {
        for constraint in contentViewConstraints {
            constraint.isActive = false
        }
        contentViewConstraints.removeAll()
        if let titleView = titleView {
            if titleView.position == TitleViewPosition.beside {
                switch titleView.alignment {
                case TitleViewAlignment.top:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: titleView.bottomAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.bottom:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: titleView.topAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.left:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: titleView.trailingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.right:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: titleView.leadingAnchor))
                }
            } else {
                contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            }
            
            
        } else {
            contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        }
        NSLayoutConstraint.activate(contentViewConstraints)
    }
    
    func activateTitleViewConstraints(view: T) {
        for constraint in titleViewConstraints {
            constraint.isActive = false
        }
        titleViewConstraints.removeAll()
        switch view.alignment {
        case .top:
            titleViewConstraints.append(view.heightAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        case .bottom:
            titleViewConstraints.append(view.heightAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        case .left:
            titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        case .right:
            titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        }
        NSLayoutConstraint.activate(titleViewConstraints)
    }
}
