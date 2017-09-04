//
//  ScrollContainerView.swift
//  youlive
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ScrollContainerView<T> : UIView, TitleViewConfigurationDelegate where T : ViewScrollable, T : UIScrollView, T : TitleConfigurable {
    
    fileprivate var contentViewConstraints = [NSLayoutConstraint]()
    fileprivate var titleViewConstraints = [NSLayoutConstraint]()
    
    var contentView : UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = contentView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(view)
                activateContentViewConstraints(view: view, titleView : titleView)
            }
        }
    }
    
    var titleView : T? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = titleView {
                view.translatesAutoresizingMaskIntoConstraints = false
                view.titleViewConfigurationDelegate = self
                self.addSubview(view)
                activateTitleViewConstraints(view: view)
                if let contentView = contentView {
                    activateContentViewConstraints(view: contentView, titleView : view)
                }
            }
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - TitleViewConfigurationDelegate_Implementation
    
    func didChangeAlignment(alignment : TitleViewAlignment) {
        if let contentView = contentView {
            activateContentViewConstraints(view: contentView, titleView : titleView)
        }
        if let titleView = titleView {
            activateTitleViewConstraints(view: titleView)
        }
    }
    
    func didChangeTitleSize(size : CGFloat) {
        if let titleView = titleView {
            activateTitleViewConstraints(view: titleView)
            if let contentView = contentView {
                activateContentViewConstraints(view: contentView, titleView : titleView)
            }
        }
    }
    
    func didChangePosition(position : TitleViewPosition) {
        if let contentView = contentView {
            activateContentViewConstraints(view: contentView, titleView : titleView)
        }
    }
    
}

//MARK: - Private_ScrollContainerView

private extension ScrollContainerView {
    func activateContentViewConstraints(view : UIView, titleView : T?) {
        for constraint in contentViewConstraints {
            constraint.isActive = false
        }
        contentViewConstraints.removeAll()
        if let titleView = titleView {
            if titleView.position == TitleViewPosition.Beside {
                switch titleView.alignment {
                case TitleViewAlignment.Top:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: titleView.bottomAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.Left:
                    contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: titleView.trailingAnchor))
                    contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.Right:
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
    
    func activateTitleViewConstraints(view : T) {
        for constraint in titleViewConstraints {
            constraint.isActive = false
        }
        titleViewConstraints.removeAll()
        switch view.alignment {
        case .Top:
            titleViewConstraints.append(view.heightAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        case .Left:
            titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        case .Right:
            titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        }
        NSLayoutConstraint.activate(titleViewConstraints)
    }
}



