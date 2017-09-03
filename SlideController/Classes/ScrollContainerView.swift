//
//  ScrollContainerView.swift
//  youlive
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ScrollContainerView<T> : UIView, TitleViewConfigurationDelegate where T : ViewScrollable, T : UIScrollView, T : TitleConfigurable {
    
    fileprivate var _contentViewConstraints = [NSLayoutConstraint]()
    fileprivate var _titleViewConstraints = [NSLayoutConstraint]()
    fileprivate var _isFirstLayout = true
    
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
        for constraint in _contentViewConstraints {
            constraint.isActive = false
        }
        _contentViewConstraints.removeAll()
        if let titleView = titleView {
            if titleView.position == TitleViewPosition.Beside {
                switch titleView.alignment {
                case TitleViewAlignment.Top:
                    _contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    _contentViewConstraints.append(view.topAnchor.constraint(equalTo: titleView.bottomAnchor))
                    _contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    _contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.Left:
                    _contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    _contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    _contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: titleView.trailingAnchor))
                    _contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
                case TitleViewAlignment.Right:
                    _contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                    _contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                    _contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                    _contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: titleView.leadingAnchor))
                }
            } else {
                _contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
                _contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
                _contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
                _contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            }
            
            
        } else {
            _contentViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            _contentViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            _contentViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            _contentViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        }
        NSLayoutConstraint.activate(_contentViewConstraints)
    }
    
    func activateTitleViewConstraints(view : T) {
        for constraint in _titleViewConstraints {
            constraint.isActive = false
        }
        _titleViewConstraints.removeAll()
        switch view.alignment {
        case .Top:
            _titleViewConstraints.append(view.heightAnchor.constraint(equalToConstant: view.titleSize))
            _titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            _titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            _titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
        case .Left:
            _titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            _titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            _titleViewConstraints.append(view.leadingAnchor.constraint(equalTo: self.leadingAnchor))
            _titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        case .Right:
            _titleViewConstraints.append(view.widthAnchor.constraint(equalToConstant: view.titleSize))
            _titleViewConstraints.append(view.topAnchor.constraint(equalTo: self.topAnchor))
            _titleViewConstraints.append(view.trailingAnchor.constraint(equalTo: self.trailingAnchor))
            _titleViewConstraints.append(view.bottomAnchor.constraint(equalTo: self.bottomAnchor))
        }
        NSLayoutConstraint.activate(_titleViewConstraints)
    }
}



