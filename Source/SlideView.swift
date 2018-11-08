//
//  ScrollContainerView.swift
//  SlideController
//
//  Created by Evgeny Dedovets on 5/6/17.
//  Copyright © 2017 Touchlane LLC. All rights reserved.
//

import UIKit

class SlideView<T>: UIView, TitleViewConfigurationDelegate where T: ViewSlidable, T: UIScrollView, T: TitleConfigurable {
    private var oldSize: CGSize = .zero
    
    var contentView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = self.contentView {
                self.addSubview(view)
            }
            self.layoutContainers()
        }
    }
    
    var titleView: T? {
        didSet {
            oldValue?.removeFromSuperview()
            if let view = self.titleView {
                view.titleViewConfigurationDelegate = self
                self.addSubview(view)
            }
            self.layoutContainers()
        }
    }
    
    override func layoutSubviews() {
        guard self.bounds.size != self.oldSize else {
            return
        }
        
        super.layoutSubviews()
        self.layoutContainers()
        self.oldSize = self.bounds.size
    }
    
    private func layoutContainers() {
        if let titleView = self.titleView {
            let alignment = titleView.alignment
            let size = titleView.titleSize
            titleView.frame = self.titleFrame(in: self.bounds, alignment: alignment, size: size)
            
            if titleView.position == TitleViewPosition.beside {
                self.contentView?.frame = self.contentFrame(in: self.bounds, alignment: alignment, size: size)
            } else {
                self.contentView?.frame = self.bounds
            }
        } else {
            self.contentView?.frame = self.bounds
        }
    }
    
    private func titleFrame(in bounds: CGRect, alignment: TitleViewAlignment, size: CGFloat) -> CGRect {
        switch alignment {
        case .top:
            return CGRect(x: 0, y: 0, width: bounds.width, height: size)
        case .bottom:
            return CGRect(x: 0, y: bounds.height - size, width: bounds.width, height: size)
        case .left:
            return CGRect(x: 0, y: 0, width: size, height: bounds.height)
        case .right:
            return CGRect(x: bounds.width - size, y: 0, width: size, height: bounds.height)
        }
    }
    private func contentFrame(in bounds: CGRect, alignment: TitleViewAlignment, size: CGFloat) -> CGRect {
        switch alignment {
        case .top:
            return CGRect(x: 0, y: size, width: bounds.width, height: bounds.height - size)
        case .bottom:
            return CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - size)
        case .left:
            return CGRect(x: size, y: 0, width: bounds.width - size, height: bounds.height)
        case .right:
            return CGRect(x: 0, y: 0, width: bounds.width - size, height: bounds.height)
        }
    }
    
    // MARK: - TitleViewConfigurationDelegateImplementation
    func didChangeAlignment(alignment: TitleViewAlignment) {
        self.layoutContainers()
    }
    
    func didChangeTitleSize(size: CGFloat) {
        if self.titleView != nil {
            self.layoutContainers()
        }
    }
    
    func didChangePosition(position: TitleViewPosition) {
        self.layoutContainers()
    }
}
